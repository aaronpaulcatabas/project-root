// backend/src/main/java/com/example/BackendApplication.java
@SpringBootApplication
@RestController
@CrossOrigin(origins = "https://localhost:3000")
public class BackendApplication {
    public static void main(String[] args) {
        SpringApplication.run(BackendApplication.class, args);
    }
    
    @GetMapping("/api/message")
    public String getMessage() {
        return "Hello from secure backend!";
    }
}