package com.salesianostriana.dam.pdam.api.payment.model;

import com.salesianostriana.dam.pdam.api.payment.model.CardType;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter
public class CardTypeConverter implements AttributeConverter<CardType, String> {

    @Override
    public String convertToDatabaseColumn(CardType cardType) {
        if (cardType == null) {
            return null;
        }
        return cardType.name();
    }

    @Override
    public CardType convertToEntityAttribute(String s) {
        if (s == null) {
            return null;
        }
        try {
            return CardType.valueOf(s);
        } catch (IllegalArgumentException e) {
            // Manejar el caso si el valor almacenado en la base de datos no coincide con ningún tipo de tarjeta válido
            return CardType.OTHER;
        }
    }
}
