import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;

public class EncryptionExample {

public static void main(String[] args) throws Exception {
 
    final String keyHex = "c6cdb2ab1154b49b4174820e87dc3d21";
    final String plaintextHex = "b70d32665aa3583117055d25d45ee958";

    SecretKey key = new SecretKeySpec(DatatypeConverter
        .parseHexBinary(keyHex), "AES");

    Cipher cipher = Cipher.getInstance("AES/ECB/NoPadding");
    cipher.init(Cipher.ENCRYPT_MODE, key);

    byte[] result = cipher.doFinal(DatatypeConverter
        .parseHexBinary(plaintextHex));

    System.out.println(DatatypeConverter.printHexBinary(result));
  }
}
