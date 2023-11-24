
module resolucaogs
    include("utils.jl")
    using URIs
    using .utils
    using HTTP            
    using DataFrames
    using CSV
    using ClassicalCiphers
    using .utils

    scraping_index() = HTTP.get("http://*.*.*.*") |> HTTP.body |> String |> 
                                                          text -> match(r" (RklBU.*) ", text) |> first |> 
                                                          String |> utils.decode
    resolucao_mundo_linux() = begin
        try
            cmd_search_base64_fiap = Cmd(`sshpass -p "schoolofrock" 
                                          ssh jackblack@1.1.1.1 -p 2003
                                              -o "passwordAuthentication=yes" grep -r "RklBUH" /`)
            out_txt = "../dados/grep_RklBUH.txt"
            err_txt = "../dados/grep_RklBUH.txt"
            run(pipeline(cmd_search_base64_fiap,stdout=out_txt,stderr=err_txt))    
        catch e
            println("Erro ao executar o comando: $e")
        end
                        
        result_grep = open("../dados/grep_RklBUH.txt") |> readlines
        result_matchs = result_grep .|> 
                        text -> match(r"(\/.*)\:.*(RklBUH[A-Za-z0-9+|A-Za-z0-9+=]{10,})",text) 
        
        df_result_filtered = filter(x -> x !== nothing,result_matchs) |> 
            data -> map(row->Dict(:path=>row.captures[1],:supct_flags=> row.captures[2], :decode64=>utils.decode(string(row.captures[2]))),data) |>
            DataFrame 
        
        CSV.write("../dados/grep_RklBUH.csv",df_result_filtered)
        return df_result_filtered
    end  
    resolucao_desafio_nota_13() = begin
        msg = read(open("../dados/desafio_13_msg.txt")) |> String
        decode64_msg = msg |> utils.decode 
        decode32_msg = decode64_msg |>String |> utils.decode_base32

            for i ∈ 1:26    
                if(contains(decrypt_caesar(decode32_msg, i)|>uppercase,"FIAP")) 
                        println("A chave é $i")
                        println(decrypt_caesar(decode32_msg, i))
                        break
                end
             end
    end
    resolucao_som_da_rede() = begin
        dadosstr = read(open("../dados/somdarede.pcapng")) |> String
        match_FIAP = match(r"(.*FIAP.*)",dadosstr) |> first |> String
        queryparampairs(match_FIAP)[2]
    end
    resolucao_windows_error() =begin
        dadosstr = readlines(open("../dados/windows_error.pcapng")) 
        matchs_ = match.(r"(.*\{.*\})",dadosstr) 
        matchs_filter = matchs_ |> filter(x->x !== nothing) |> 
                                d->map(x->x.match,d)
        println(matchs_filter)
    end
    resolucao_mr_robot() = begin
        dadosstr = read(open("../dados/robot2.jpeg")) |> String |> x->split(x,'\0')
        println.(dadosstr)
        matchs_ = match.(r".*\{.*\}",dadosstr)         
        matchs_filter = matchs_ |> filter(x->x !== nothing) |> d->map(x->x.match,d)        
        println(matchs_filter)
    end
end