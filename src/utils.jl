module utils    
    using  Base64
    using CodecBase
    export decode  
      
    decode =(encoded::String)->base64decode(encoded) |> String
    decode_base32=(encoded::String)->transcode(Base32Decoder(),encoded) |>
     String
end 
