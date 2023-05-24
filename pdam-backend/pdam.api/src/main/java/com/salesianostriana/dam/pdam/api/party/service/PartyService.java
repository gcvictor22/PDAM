package com.salesianostriana.dam.pdam.api.party.service;

import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.discotheque.repository.DiscothequeRepository;
import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.event.repository.EventRepository;
import com.salesianostriana.dam.pdam.api.event.service.EventService;
import com.salesianostriana.dam.pdam.api.exception.accesdenied.EventDeniedAccessException;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyDiscothequeListException;
import com.salesianostriana.dam.pdam.api.exception.notfound.DiscothequeNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.PartyNotFoundException;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.party.dto.GetPartyDto;
import com.salesianostriana.dam.pdam.api.party.dto.NewPartyDto;
import com.salesianostriana.dam.pdam.api.party.model.Party;
import com.salesianostriana.dam.pdam.api.party.repository.PartyRepository;
import com.salesianostriana.dam.pdam.api.payment.model.PaymentMethod;
import com.salesianostriana.dam.pdam.api.payment.service.PaymentMethodService;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.search.specifications.post.PSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
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
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.List;

@Service
@AllArgsConstructor
public class PartyService {

    private final PartyRepository partyRepository;
    private final DiscothequeRepository discothequeRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;
    private final PaymentMethodService paymentMethodService;

    private final JavaMailSender javaMailSender;


    public GetPageDto<GetPartyDto> findAll(List<SearchCriteria> params, Pageable pageable) {

        if (discothequeRepository.findAll().isEmpty())
            throw new EmptyDiscothequeListException();

        PSBuilder psBuilder = new PSBuilder(params);

        Specification<Post> spec = psBuilder.build();
        Page<GetPartyDto> getListDto = partyRepository.findAll(spec, pageable).map(GetPartyDto::of);

        return new GetPageDto<>(getListDto);

    }

    public GetPartyDto save(NewPartyDto newPartyDto, User loggedUser){

        Discotheque discotheque = discothequeRepository.findById(loggedUser.getAuthEvent().getId()).orElseThrow(() -> new DiscothequeNotFoundException(loggedUser.getAuthEvent().getId()));

        Party party = Party.builder()
                .name(newPartyDto.getName())
                .description(newPartyDto.getDescription())
                .discotheque(discotheque)
                .startAt(newPartyDto.getStartAt())
                .endsAt(newPartyDto.getEndsAt())
                .adult(newPartyDto.isAdult())
                .price(newPartyDto.getPrice())
                .drinkIncluded(newPartyDto.isDrinkIncluded())
                .numberOfDrinks(newPartyDto.getNumberOfDrinks())
                .build();

        partyRepository.save(party);
        discotheque.getParties().add(party);
        discothequeRepository.save(discotheque);

        return GetPartyDto.of(party);
    }

    public Party buy(Long id, User loggedUser) throws MessagingException, IOException {
        Party party = partyRepository.findById(id).orElseThrow(() -> new PartyNotFoundException(id));
        Event event = party.getDiscotheque();

        party.getClients().add(loggedUser);
        loggedUser.getParties().add(party);
        event.getClients().add(loggedUser);
        loggedUser.getEvents().add(event);

        eventRepository.save(event);
        userRepository.save(loggedUser);

        MimeMessage message = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);

        PDDocument document = new PDDocument();
        PDPage page = new PDPage();
        document.addPage(page);

        PDPageContentStream contentStream = new PDPageContentStream(document, page);
        contentStream.beginText();
        contentStream.setFont(PDType1Font.HELVETICA_BOLD, 12);
        contentStream.newLineAtOffset(100, 700);
        contentStream.showText("Metodo de pago activo: "+paymentMethodService.getActiveMethod(loggedUser).getNumber());
        contentStream.endText();
        contentStream.close();

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        document.save(outputStream);
        document.close();

        helper.setFrom("no.reply.dyscotkeo@gmail.com");
        helper.setTo(loggedUser.getEmail());
        message.setSubject("¡Compra realizada con éxito "+loggedUser.getUsername()+"!");

        javax.mail.internet.MimeBodyPart attachment = new javax.mail.internet.MimeBodyPart();
        attachment.setContent(outputStream.toByteArray(), "application/pdf");
        attachment.setFileName("example.pdf");

        javax.mail.internet.MimeMultipart multipart = new javax.mail.internet.MimeMultipart();
        multipart.addBodyPart(attachment);

        message.setContent(multipart);

        javaMailSender.send(message);

        return  partyRepository.save(party);
    }

    public void setUpdatedPopularity(Event event){
        if (event.getCity().getUsersWhoLive().size() > 0){
            event.setPopularity(eventRepository.popularityCityEvent(event.getCity().getId(), event.getId()));
            eventRepository.save(event);
        }
    }
}
