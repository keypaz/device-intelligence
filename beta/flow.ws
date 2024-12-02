@startuml
entity     Keypaz     as f
participant SDK as sdk
entity       Application       as app
entity    "Merchant Server"    as server
entity     "Keypaz's Server"     as fs

sdk --> app : Implementation
app -> sdk : Request Id
sdk --> f : Secret Request
sdk -> app :
note right of sdk
Keypaz ID
TRX ID
end note
app->server : Sending ID

== Detail Information ==
alt White Listed IP
    server -> fs : Analyze Request
    note right of server
        TRX ID
    end note
    fs-->server: Response
    note left of fs
        Data Detail
    end note    
end
@enduml