@startuml
participant SDK as sdk
entity       Application       as app
entity    "Merchant Server"    as server
entity     Keypaz     as f

sdk --> app : Implementation
app -> sdk : Request Meta
sdk -> sdk : Generating Meta
sdk --> app :
note right of sdk
Meta
end note
app->server : Sending Meta
alt White Listed IP
    server -> f: Analyze Request
    note right of server
        Meta
        PIC Id
        Merchant App Id
        Merchant Key (Header)
    end note
    f-->server: Response
    note left of f
        Data Detail
    end note    
end
@enduml