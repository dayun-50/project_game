package controllers;

import java.io.IOException;
import java.util.Properties;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/sendEmailAuth.MembersController")
public class EmailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 서버 전용 Naver 계정 (실제 발송용)
    private static final String FROM_EMAIL = ""; // 서버 전용 네이버 계정
    private static final String APP_PASSWORD = "";     // 네이버 앱 비밀번호

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        String toEmail = request.getParameter("email"); // 사용자가 입력한 이메일
        String authCode = generateAuthCode();           // 6자리 인증번호

        try {
            sendEmail(toEmail, authCode);
            response.getWriter().write(authCode); // JSP에서 입력값 확인용
        } catch (MessagingException e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("fail");
        }
    }

    // 6자리 인증번호 생성
    private String generateAuthCode() {
        int code = (int) (Math.random() * 900000) + 100000;
        return String.valueOf(code);
    }

    // 이메일 발송
    private void sendEmail(String toEmail, String code) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.naver.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.debug", "true");

        // 서버 계정 인증
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        // 메일 작성
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("[혜빈이와 아이들] 회원가입 인증번호");
        message.setText("회원가입 인증번호는 " + code + " 입니다.\n\n감사합니다.");

        // 메일 발송
        Transport.send(message);
    }
}
