# yc_security_group_rules

Инструмент для управления Security Group Rules в Yandex Cloud.

Для запуска необходимо:

* Иметь активную инициализацию в CLI Yandex Cloud (`yc init`), позволяющую запусть команды `yc <commands>`    
* Установить переменную окружения `$SECURITY_GROUP_NAME` 
  (Имя [группы безопасности](https://cloud.yandex.ru/docs/vpc/concepts/security-groups))
      
      SECURITY_GROUP_NAME=your_security_group_name
  
* Или вписать ее в заголовке скрипта `yc_security_group_rules.sh`
* Теперь можно запустить скрипт и получить справку по командам
      
      ./yc_security_group_rules.sh
      
## Сценарии использования

### Быстрое обновление собственного динамического IP-адреса в правиле доступа к ресурсам Yandex Cloud 

Создание правила группы безопасности c CIDR = текущий IP пользователя

    ./yc_security_group_rules.sh new <rule-description-123>
  
Обновление IP-адреса правила

    ./yc_security_group_rules.sh update <rule-description-123>
 
