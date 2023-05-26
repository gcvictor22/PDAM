package com.salesianostriana.dam.pdam.api.festival.service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.salesianostriana.dam.pdam.api.city.repository.CityRepository;
import com.salesianostriana.dam.pdam.api.event.dto.GetEventDto;
import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.event.model.EventType;
import com.salesianostriana.dam.pdam.api.event.repository.EventRepository;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyFestivalListException;
import com.salesianostriana.dam.pdam.api.exception.notfound.CityNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.EventNotFoundException;
import com.salesianostriana.dam.pdam.api.festival.dto.NewFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.model.Festival;
import com.salesianostriana.dam.pdam.api.festival.repository.FestivalRepository;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.payment.service.PaymentMethodService;
import com.salesianostriana.dam.pdam.api.search.specifications.festival.FSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentConfirmParams;
import com.stripe.param.PaymentIntentCreateParams;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.graphics.form.PDFormXObject;
import org.apache.pdfbox.pdmodel.graphics.image.LosslessFactory;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.util.Matrix;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.EnumSet;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FestivalService {

    private final FestivalRepository festivalRepository;
    private final CityRepository cityRepository;

    private final PaymentMethodService paymentMethodService;
    private final UserRepository userRepository;

    private final EventRepository eventRepository;
    private final JavaMailSender javaMailSender;


    @Value("${secret.stripe.key}")
    private String stripeSecret;

    public GetPageDto<GetEventDto> findAll(List<SearchCriteria> params, Pageable pageable) {
        if (festivalRepository.findAll().isEmpty()){
            throw new EmptyFestivalListException();
        }

        FSBuilder psBuilder = new FSBuilder(params);

        Specification<Festival> spec = psBuilder.build();
        Page<GetEventDto> pageGetDiscothequeDto = festivalRepository.findAll(spec, pageable).map(GetEventDto::of);

        return new GetPageDto<>(pageGetDiscothequeDto);
    }

    public GetEventDto save(NewFestivalDto newFestivalDto) {

        Festival festival = Festival.builder()
                .name(newFestivalDto.getName())
                .description(newFestivalDto.getDescription())
                .location(newFestivalDto.getLocation())
                .city(cityRepository.findById(newFestivalDto.getCityId()).orElseThrow(() -> new CityNotFoundException(newFestivalDto.getCityId())))
                .capacity(newFestivalDto.getCapacity())
                .dateTime(newFestivalDto.getDateTime())
                .duration(newFestivalDto.getDuration())
                .price(newFestivalDto.getPrice())
                .drinkIncluded(newFestivalDto.isDrinkIncluded())
                .numberOfDrinks(newFestivalDto.getNumberOfDrinks())
                .adult(newFestivalDto.isAdult())
                .type(EnumSet.of(EventType.FESTIVAL))
                .imgPath("default-events.png")
                .build();

        return GetEventDto.of(festivalRepository.save(festival));
    }

    public Festival buy(Long id, User loggedUser) {
        Festival festival = festivalRepository.findById(id).orElseThrow(() -> new EventNotFoundException(id));

        festival.getClients().add(loggedUser);
        loggedUser.getEvents().add(festival);

        userRepository.save(loggedUser);

        return festivalRepository.save(festival);
    }

    public void setUpdatedPopularity(Event event){
        if (event.getCity().getUsersWhoLive().size() > 0){
            event.setPopularity(eventRepository.popularityCityEvent(event.getCity().getId(), event.getId()));
            eventRepository.save(event);
        }
    }

    public PaymentIntent createStripe(Festival festival, User loggedUser) {
        try {
            Stripe.apiKey = stripeSecret;

            PaymentIntentCreateParams.Builder builder = new PaymentIntentCreateParams.Builder()
                    .setCurrency("eur")
                    .setAmount((long) festival.getPrice()*100)
                    .setDescription(festival.getName()+" // "+festival.getDescription())
                    .setCustomer(loggedUser.getStripeCustomerId())
                    .setPaymentMethod(paymentMethodService.getActiveMethod(loggedUser).getStripe_id());

            return PaymentIntent.create(builder.build());

        }catch (StripeException e) {
            throw new RuntimeException(e);
        }
    }

    public void confirmStripe(String id, User loggedUser) throws IOException, MessagingException, WriterException {

        try {

            Stripe.apiKey = stripeSecret;

            PaymentIntent paymentIntent = PaymentIntent.retrieve(id);
            PaymentIntentConfirmParams.Builder builder = new PaymentIntentConfirmParams.Builder()
                    .setPaymentMethod(paymentMethodService.getActiveMethod(loggedUser).getStripe_id());

            paymentIntent.confirm(builder.build());

            ////////////////////////////////////////////////

            Event event = loggedUser.getEvents().get(loggedUser.getEvents().size()-1);
            ByteArrayOutputStream outputStream = createBill(loggedUser, (Festival) event);

            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setFrom("no.reply.dyscotkeo@gmail.com");
            helper.setTo(loggedUser.getEmail());
            message.setSubject("¡Compra realizada con éxito "+loggedUser.getUsername()+"!");

            javax.mail.internet.MimeBodyPart attachment = new javax.mail.internet.MimeBodyPart();
            attachment.setContent(outputStream.toByteArray(), "application/pdf");
            attachment.setFileName("Entrada "+event.getName()+".pdf");

            javax.mail.internet.MimeMultipart multipart = new javax.mail.internet.MimeMultipart();
            multipart.addBodyPart(attachment);

            message.setContent(multipart);

            javaMailSender.send(message);

        } catch (StripeException | WriterException e) {
            throw new RuntimeException(e);
        }

    }

    public ByteArrayOutputStream createBill(User loggedUser, Festival event) throws WriterException, IOException {
        BitMatrix qr =generateQRCode(event, loggedUser);

        PDDocument document = new PDDocument();
        PDPage page = new PDPage();
        document.addPage(page);

        PDImageXObject qrCodeImage = LosslessFactory.createFromImage(document, toBufferedImage(qr));

        PDPageContentStream contentStream = new PDPageContentStream(document, page);

        String imagePath = "uploads/bill-logo.jpeg";
        PDImageXObject image = PDImageXObject.createFromFile(imagePath, document);
        float imageWidth = image.getWidth()/4f;
        float imageHeight = image.getHeight()/4f;
        float imageX = page.getMediaBox().getWidth() - imageWidth - 50; // Posición X de la imagen (descontando un margen de 50 unidades)
        float imageY = page.getMediaBox().getHeight() - imageHeight - 50; // Posición Y de la imagen (descontando un margen de 50 unidades)
        contentStream.drawImage(image, imageX, imageY, imageWidth, imageHeight);

        float startX = 50;
        float startY = page.getMediaBox().getHeight() - 50;
        float lineWidth = 2.5f;
        float lineLength = 135;
        float textYOffset = 20;

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA_BOLD, 15);
        contentStream.newLineAtOffset(startX + 24, startY - textYOffset);
        contentStream.showText("DISCOTKEO");
        contentStream.endText();

        float lineStartX = startX + lineWidth / 2;
        float lineEndX = lineStartX + lineLength;
        float lineY = startY - textYOffset - lineWidth - 10;
        contentStream.setLineWidth(lineWidth);
        contentStream.moveTo(lineStartX, lineY);
        contentStream.lineTo(lineEndX, lineY);
        contentStream.stroke();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA_BOLD, 25);
        contentStream.newLineAtOffset(startX + 10, lineY - 30);
        contentStream.showText("ENTRADA");
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        contentStream.newLineAtOffset(startX, lineY - 150);
        contentStream.showText("DETALLES DE FIESTA");
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        float textWidth = PDType1Font.HELVETICA.getStringWidth("DETALLES DE COMPRA") / 1000f * 12;
        contentStream.newLineAtOffset(page.getMediaBox().getWidth() - textWidth - 50, lineY - 150);
        contentStream.showText("DETALLES DE COMPRA");
        contentStream.endText();

        contentStream.setLineWidth(1.0f); // Ancho de la línea (en puntos)
        contentStream.moveTo(50, lineY - 160);
        contentStream.lineTo(page.getMediaBox().getWidth() - 50, lineY - 160);
        contentStream.stroke();

        float startYDatails = lineY - 190;

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA_BOLD, 12);
        contentStream.newLineAtOffset(startX, startYDatails);
        contentStream.showText(event.getName().toUpperCase());
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        contentStream.newLineAtOffset(startX, startYDatails - 20);
        contentStream.showText("Ubicación: "+event.getCity().getName());
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        contentStream.newLineAtOffset(startX, startYDatails - 40);
        contentStream.showText(event.isAdult() ? "Se requiere la mayoría de edad (+18)" : "No se requiere la mayoría de edad");
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        contentStream.newLineAtOffset(startX, startYDatails - 60);
        contentStream.showText(event.isDrinkIncluded() ? "Consumición/nes incluidas : "+String.valueOf(event.getNumberOfDrinks()) : "Sin consumición incluida");
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        contentStream.newLineAtOffset(startX, startYDatails - 80);
        contentStream.showText("Fecha: "+event.getDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        contentStream.newLineAtOffset(startX, startYDatails - 100);
        contentStream.showText("Duración: "+event.getDuration()+" días");
        contentStream.endText();

        String eventImgPath = "uploads/" + event.getImgPath();
        PDImageXObject eventImage = PDImageXObject.createFromFile(eventImgPath, document);
        float eventImageWidth = 1920/7f;
        float eventImageHeight = eventImageWidth*0.5625f;
        contentStream.drawImage(eventImage, 50, startYDatails - eventImageHeight - 120, eventImageWidth, eventImageHeight);

        /////////////////////////////////////////////////////////////////

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        contentStream.newLineAtOffset(page.getMediaBox().getWidth() - textWidth - 50, startYDatails);
        contentStream.showText("Fecha: "+ LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        contentStream.newLineAtOffset(page.getMediaBox().getWidth() - textWidth - 50, startYDatails - 20);
        contentStream.showText("Precio: "+event.getPrice()*0.79+"€");
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 12);
        contentStream.newLineAtOffset(page.getMediaBox().getWidth() - textWidth - 50, startYDatails - 40);
        contentStream.showText("IVA: "+event.getPrice()*0.21+"€");
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA_BOLD, 12);
        contentStream.newLineAtOffset(page.getMediaBox().getWidth() - textWidth - 50, startYDatails - 80);
        contentStream.showText("TOTAL");
        contentStream.endText();

        contentStream.setLineWidth(1.0f); // Ancho de la línea (en puntos)
        contentStream.moveTo(page.getMediaBox().getWidth() - textWidth - 50, startYDatails - 90);
        contentStream.lineTo(page.getMediaBox().getWidth() - 50, startYDatails - 90);
        contentStream.stroke();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA, 15);
        contentStream.newLineAtOffset(page.getMediaBox().getWidth() - textWidth - 50, startYDatails - 110);
        contentStream.showText(event.getPrice()+"€");
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA_BOLD, 25);
        contentStream.newLineAtOffset(startX, 110);
        contentStream.showText("¡MUCHAS GRACIAS");
        contentStream.endText();

        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA_BOLD, 25);
        contentStream.newLineAtOffset(startX + 10, 80);
        contentStream.showText("POR SU COMPRA!");
        contentStream.endText();

        contentStream.drawImage(qrCodeImage, page.getMediaBox().getWidth() - 210, 10);

        contentStream.close();


        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        document.save(outputStream);
        document.close();

        return outputStream;
    }

    public static BufferedImage toBufferedImage(BitMatrix matrix) {
        int width = matrix.getWidth();
        int height = matrix.getHeight();
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                image.setRGB(x, y, (matrix.get(x, y) ? Color.BLACK.getRGB() : Color.WHITE.getRGB()));
            }
        }
        return image;
    }

    public static BitMatrix generateQRCode(Event event, User user) throws WriterException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        return qrCodeWriter.encode((event.getId()+user.getId().toString()+ LocalDateTime.now()), BarcodeFormat.QR_CODE, 200, 200);
    }

    public void cancelStripe(String id) {
        try {

            Stripe.apiKey = stripeSecret;

            PaymentIntent.retrieve(id).cancel();

        } catch (StripeException e) {

            throw new RuntimeException();
        }
    }
}