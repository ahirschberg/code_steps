public class Example {
    public static void main(String... args) {
        {{2+ Set<String> mySet ~}} = {{2+ new HashSet<>() ~}};
        {{3+ Object o = new HashSet<String>() ~}};
        {{4- Set<String> s ~}} = {{4- o ~}};
    }
}
