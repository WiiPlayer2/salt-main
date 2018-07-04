#!/usr/bin/env python3

import json
import os
import io
import serial
import paho.mqtt.client as mqtt

def dump(obj):
   for attr in dir(obj):
       if hasattr( obj, attr ):
           print( "obj.%s = %s" % (attr, getattr(obj, attr)))

class Config():
    def __init__(self):
        self._json_data = {}
        if os.path.isfile('config.json'):
            with open('config.json', 'r') as f:
                self._json_data = json.load(f)

        self.mqtt_state_topic = self.get_mqtt_hostname()
        self.mqtt_command_topic = "{}/set".format(self.get_mqtt_hostname())
        self.mqtt_lwt_topic = "{}/status".format(self.get_mqtt_hostname())

    def _get(self, key, default):
        if key in self._json_data:
            return self._json_data[key]
        else:
            self._json_data[key] = default
            return default
    
    def _set(self, key, value):
        self._json_data[key] = value

    def is_discovered(self) -> bool:
        return False
        #return self._get('is_discovered', False)

    def set_is_discovered(self, value: bool):
        self._set('is_discovered', value)

    def get_tty_dev(self) -> str:
        return self._get('tty_dev', '')

    def get_mqtt_host(self) -> str:
        return self._get('mqtt_host', '')

    def get_mqtt_port(self) -> int:
        return self._get('mqtt_port', 1883)

    def get_mqtt_user(self) -> str:
        return self._get('mqtt_user', '')

    def get_mqtt_password(self) -> str:
        return self._get('mqtt_password', '')

    def get_mqtt_ha_discovery_prefix(self) -> str:
        return self._get('mqtt_ha_discovery_prefix', '')

    def get_mqtt_hostname(self) -> str:
        return self._get('mqtt_hostname', '')

    def save(self):
        with open('config.json', 'w') as f:
            json.dump(self._json_data, f, indent=2)

class Light():
    CMD_SET_BRIGHTNESS = 0xF1
    CMD_SET_COLOR = 0xF2

    def __init__(self, tty: str):
        self._brightness = 128
        self._color = (255, 255, 255)
        self._state = False
        self._tty_name = tty
        try:
            self._tty = serial.Serial(cfg.get_tty_dev(), 9600)
        except Exception as e:
            print(e)
            print('''
            =========================================
            /!\\ COULDN\'T OPEN TTY - USING BytesIO /!\\
            =========================================
            ''')
            self._tty = io.BytesIO()

    def _write(self, *values):
        data = bytearray(values)
        print('Writing {} to {}'.format(data, self._tty_name))
        self._tty.write(data)
        self._tty.flush()

    def _read(self, count=8):
        data = self._tty.read(count)
        print('Read {} from {}'.format(data, self._tty_name))
        return data

    def set_state(self, value: bool):
        self._state = value
        if value:
            self._write(Light.CMD_SET_BRIGHTNESS, self._brightness)
        else:
            self._write(Light.CMD_SET_BRIGHTNESS, 0)

    def set_brightness(self, value: int):
        self._brightness = value
        self._write(Light.CMD_SET_BRIGHTNESS, value)
    
    def set_color(self, r: int, g: int, b: int):
        self._color = (r, g, b)
        self._write(Light.CMD_SET_COLOR, r, g, b)

    def create_state_json(self):
        return json.dumps({
            'state': 'ON' if self._state else 'OFF',
            'brightness': self._brightness if self._state else 0,
            'color': {
                'r': self._color[0],
                'g': self._color[1],
                'b': self._color[2]
            }
        })

def on_connect(client: mqtt.Client, userdata, flags, rc):
    if not cfg.is_discovered():
        md = {
            'name': cfg.get_mqtt_hostname(),
            'platform': 'mqtt_json',
            'state_topic': cfg.mqtt_state_topic,
            'command_topic': cfg.mqtt_command_topic,
            'brightness': True,
            'rgb': True
        }
        data = json.dumps(md)
        dc_topic = '{}/light/{}/config'.format(cfg.get_mqtt_ha_discovery_prefix(), cfg.get_mqtt_hostname())

        client.publish(dc_topic, data)
        cfg.set_is_discovered(True)
        cfg.save()

    client.subscribe(cfg.mqtt_command_topic)
    client.publish(cfg.mqtt_lwt_topic, 'online')
    client.publish(cfg.mqtt_state_topic, light.create_state_json())

def on_message(client: mqtt.Client, userdata, message: mqtt.MQTTMessage):
    if message.topic == cfg.mqtt_command_topic:
        try:
            msg = message.payload.decode('utf-8')
            print(msg)
            data = json.loads(msg)

            if 'brightness' in data:
                light.set_brightness(data['brightness'])
            if 'color' in data:
                light.set_color(data['color']['r'], data['color']['g'], data['color']['b'])
            if 'state' in data:
                light.set_state(data['state'] == 'ON')

            json_state = light.create_state_json()
            client.publish(cfg.mqtt_state_topic, json_state)
            print(json_state)
        except:
            pass

def on_log(client: mqtt.Client, userdata, level, buf):
    print(level, buf)

cfg = Config()
light = Light(cfg.get_tty_dev())

client = mqtt.Client(cfg.get_mqtt_hostname())
client.on_connect = on_connect
client.on_message = on_message
client.on_log = on_log

client.username_pw_set(cfg.get_mqtt_user(), cfg.get_mqtt_password())
client.connect(cfg.get_mqtt_host(), cfg.get_mqtt_port())
client.loop_forever(retry_first_connection=True)
