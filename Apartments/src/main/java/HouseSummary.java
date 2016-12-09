/**
 * Created by michael on 08.12.16.
 */

public class HouseSummary {
    public final Apartment apartment;
    public final Rate rate;

    public HouseSummary(String name, String country, Integer roomsCnt, Integer bedsCnt,
                        Integer guestsCnt, Float location, Float cleanliness, Float friendliness) {
        apartment = new Apartment(name, country, roomsCnt, bedsCnt, guestsCnt);
        rate = new Rate(location, cleanliness, friendliness);
    }

    @Override
    public String toString() {
        return apartment.toString() + "\n ~~~ " + rate.toString();
    }
}
