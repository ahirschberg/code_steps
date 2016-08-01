public class Example {
    public static void main(String... args) {
//~     |  a |            |    v    ||   a    |v
        String myString = new String("string a");
//~     |  b |            |   c    |
        Object strAsObj = "string b";
//~     |  d |               |  e    ||   d  |
        String otherString = (String) strAsObj;
    }
}
