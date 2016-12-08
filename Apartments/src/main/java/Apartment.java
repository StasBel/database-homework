/**
 * Created by michael on 08.12.16.
 */

import com.neovisionaries.i18n.CountryCode;

public class Apartment {
    public static String countryIdToStr(String id) {
        return CountryCode.getByCode(id).getName();
    }

    public final String name;
    public final String country;
    public final Integer roomsCnt;
    public final Integer bedsCnt;
    public final Integer guestsCnt;

    public Apartment(String name, String country, int roomsCnt, int bedsCnt, int guestsCnt) {
        this.name = name;
        this.country = country;
        this.roomsCnt = roomsCnt;
        this.bedsCnt = bedsCnt;
        this.guestsCnt = guestsCnt;
    }


    @Override
    public String toString() {
        return "Apartment{" + "name=" + name + ", country=" + country
                + ", rooms=" + roomsCnt + ", beds=" + bedsCnt + ", guests" + guestsCnt + "}";
    }
}