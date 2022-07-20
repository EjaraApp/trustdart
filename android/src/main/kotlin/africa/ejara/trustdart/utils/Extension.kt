package africa.ejara.trustdart.utils

import africa.ejara.trustdart.Numeric
import android.util.Base64
import com.google.protobuf.ByteString

fun ByteArray.toHex(): String {
    return Numeric.toHexString(this)
}

fun String.toHexBytes(): ByteArray {
    return Numeric.hexStringToByteArray(this)
}

fun String.toHexByteArray(): ByteArray {
    return Numeric.hexStringToByteArray(this)
}

fun String.toByteString(): ByteString {
    return ByteString.copyFrom(this, Charsets.UTF_8)
}

fun String.toHexBytesInByteString(): ByteString {
    return ByteString.copyFrom(this.toHexBytes())
}

fun ByteArray.base64String(): String {
    return Base64.encodeToString(this, Base64.DEFAULT).toString()
}