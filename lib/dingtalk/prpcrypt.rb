module Dingtalk
  module Prpcrypt
    extend self

    def decrypt(aes_key, text, corpid)
      status = 200
      text        = Base64.decode64(text)
      text        = handle_cipher(:decrypt, aes_key, text)
      result      = PKCS7Encoder.decode(text)
      content     = result[16...result.length]
      len_list    = content[0...4].unpack("N")
      xml_len     = len_list[0]
      xml_content = content[4...4 + xml_len]
      from_corpid = content[xml_len+4...content.size]
      if corpid == from_corpid
        return xml_content
      end
      raise Dingtalk::Exception::CorpError.new
    end

    def encrypt(aes_key, text, corpid)
      text    = text.force_encoding("ASCII-8BIT")
      random  = SecureRandom.hex(8)
      msg_len = [text.length].pack("N")
      text    = "#{random}#{msg_len}#{text}#{corpid}"
      text    = PKCS7Encoder.encode(text)
      text    = handle_cipher(:encrypt, aes_key, text)
      Base64.encode64(text)
    end

    private
    def handle_cipher(action, aes_key, text)
      cipher = OpenSSL::Cipher.new('AES-256-CBC')
      cipher.send(action)
      cipher.padding = 0
      cipher.key     = aes_key
      cipher.iv      = aes_key[0...16]
      cipher.update(text) + cipher.final
    end
  end
end
