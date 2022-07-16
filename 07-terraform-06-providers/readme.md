## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   

#### Ответ:
resource:
[https://github.com/hashicorp/terraform-provider-aws/blob/341ef9448ff56250ca3ed9d6b69600d42f4251b6/internal/provider/provider.go#L867-L1984](https://github.com/hashicorp/terraform-provider-aws/blob/341ef9448ff56250ca3ed9d6b69600d42f4251b6/internal/provider/provider.go#L867-L1984)

data_source:
[https://github.com/hashicorp/terraform-provider-aws/blob/341ef9448ff56250ca3ed9d6b69600d42f4251b6/internal/provider/provider.go#L412-L865](https://github.com/hashicorp/terraform-provider-aws/blob/341ef9448ff56250ca3ed9d6b69600d42f4251b6/internal/provider/provider.go#L412-L865)


1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    
    name конфликтует с name_prefix. [Cсылка](https://github.com/hashicorp/terraform-provider-aws/blob/6e6e4bed78f29b0addd5b33fd733b67f85bb4dc3/internal/service/sqs/queue.go#L87)

    * Какая максимальная длина имени? 
    80 символов [Ссылка](https://github.com/hashicorp/terraform-provider-aws/blob/6e6e4bed78f29b0addd5b33fd733b67f85bb4dc3/internal/service/sqs/queue.go#L424-L432)
    * Какому регулярному выражению должно подчиняться имя? 
    Если параметр функции resourceQueueCustomizeDiff fifoQueue ИСТИНА, то имя должно подчиняться регулярному выражению
    ```
    `^[a-zA-Z0-9_-]{1,75}\.fifo$
    ```
    
    иначе
    
    ```
    ^[a-zA-Z0-9_-]{1,80}$
    ```
    
