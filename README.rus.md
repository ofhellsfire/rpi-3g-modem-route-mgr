# RPi 3G Modem Route Mgr - Деревенский интернет

Проект описывает одно из возможных решений проблем с интернетом в местности с плохим покрытием сотовых сетей.

Решение использует следующее:
- 3G USB Modem
- RaspberryPI (RPi)
- Самодельная антенна (или покупная антенна)

В данном решении RPi используется по сути в качестве роутера.

> **Заметка**:
> Решение предполагает, что внутри дома 3G связь отсутствует, либо есть только нестабильный 2G

## Варианты

### Вариант 1

![Alternative 1](https://github.com/ofhellsfire/rpi-3g-modem-route-mgr/blob/master/static/images/solution_diagram_01.png)

Вариант 1 преполагает вынесение RPi и 3G модема в отдельное помещение, в котором 3G модем (или 3G модем + антенна) дают устойчивый сигнал.

*Минусы:*
- протяжка Ethernet кабеля через комнату
- много кабелей/проводов (если нет готовых разводок в отдельном помещении)

### Вариант 2

![Alternative 1](https://github.com/ofhellsfire/rpi-3g-modem-route-mgr/blob/master/static/images/solution_diagram_02.png)

Вариант 2 предполагает использование мачты на которой крепится антенна. Качественный антенный кабель соединяется с антенной и заводится внутрь дома, где подключается к 3G модему.

*Минусы:*
- подключение только одного компьютера

### Вариант 3

![Alternative 1](https://github.com/ofhellsfire/rpi-3g-modem-route-mgr/blob/master/static/images/solution_diagram_03.png)

Вариант 3 - это слегка изменненный Вариант 2, где добавлен Switch для возможности подключения нескольких устройств.

## Роль RPi

TBD

## Конфигурация (manual)

```
# Включить поддержку IP forwarding
echo 'net.ipv4.ip_forward=1' | sudo tee --apend /etc/sysctl.conf

# Установить Pi-Hole
sudo apt-get install git vim
git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole
cd Pi-hole/automated\ install/
sudo bash basic-install.sh
sudo apt-get upgrade
sudo apt autoremove
# Сконфигурировать Pi-Hole из web admin
```
