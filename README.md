# yc_security_group_rules

Инструмент для управления Security Group Rules в Yandex Cloud.

Для запуска необходимо:

* Настроить/авторизоваться в CLI Yandex Cloud (`yc`)
    
      yc init
    
* Установить переменную окружения `$SECURITY_GROUP_NAME` 
  (Имя [группы безопасности](https://cloud.yandex.ru/docs/vpc/concepts/security-groups))
      
      SECURITY_GROUP_NAME=your_security_group_name
  
* Или вписать ее в заголовке скрипта `yc_security_group_rules.sh`

* Теперь можно запустить скрипт и получить справку по командам
      
      ./yc_security_group_rules.sh
      
## Сценарии использования

### Быстрое обновление динамического IP-адреса для доступа к ресурасам Yandex Cloud

Создание правила группы безопасности c CIDR = текущий публичный IP пользователя

    ./yc_security_group_rules.sh new <description>
  
Регулярное обновление IP-адреса правила по полю description

    ./yc_security_group_rules.sh update <description>
 
