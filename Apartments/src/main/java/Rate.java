/**
 * Created by michael on 08.12.16.
 */

public class Rate {
    public final Float location;
    public final Float cleanliness;
    public final Float friendliness;

    public Rate(Float location, Float cleanliness, Float friendliness) {
        this.location = location;
        this.cleanliness = cleanliness;
        this.friendliness = friendliness;
    }

    @Override
    public String toString() {
        return "RATING:: location = " + location + ", cleanliness = " + cleanliness + ", friendliness = " + friendliness;
    }

}
