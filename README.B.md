# Keypaz
![Logo](/beta/1.jpg)
![Logo](/beta/2.jpg)
![Logo](/beta/3.jpg)
![Logo](/beta/4.jpg)


# Development
## Choose your stack technology and install it.

| No | Stack Technology | Link 		                                                                  |
| -- | --	 			|--------------------------------------------------------------------------|
| 1  | Android Native  	| [Link](/alpha/README.ANDROID.md)  		     |
| 2  | IOS Native		| [Link](/alpha/README.IOS.md)  			        |
| 3  | Flutter			| [Link](/alpha/README.FLUTTER.md) 		     |
| 4  | React Native		| [Link](/alpha/README.RN.md)  	 |
| 5  | Web Browser		| [Web Browser](/alpha/README.WEB.md) |   
This sdk will generate TRX ID that will be used to get detail information.

## Whitelist IP
Whitelist IP is used to secure your API from unauthorized access. You can whitelist your IP in [here](https://fazpass.com).

## Endpoint Request Body
BASE URL IS : https://api.keypaz.com/analyze
```JSON
{
    "pic_id":"085798504000",
    "trx_id":"{{TRX_ID}}"
}
```

# What We Server
```JSON
{
  "identification": {
    "data": {
      "trx_id": "99887d7e-f9e0-48e8-bba0-dc5defe195f9",
      "challenge": "7eeb4053-a862-444b-8807-daca6a14fc6b",
      "fazpass_id": "180b774893da520648f4b3204da464555b0c6bc6ead7e205",
      "confidence": {
                    "score": 170,
                    "level": "LOW"
                },
      "is_active": false,
      "time_stamp": 1732615823,
      "platform": "ios",
      "application": "com.fazpass.td-showcase-mobile",
      "is_notifiable": true
    }
  },
  "features": {
    "data": {
      "version": "v2",
      "device_intelligence": true
    }
  },
  "root": {
    "data": {
      "result": false
    }
  },
  "emulator": {
    "data": {
      "result": false
    }
  },
  "tempering": {
    "data": {
      "result": false
    }
  },
  "clonning": {
    "data": {
      "result": false
    }
  },
  "screen_sharing": {
    "data": {
      "result": false
    }
  },
  "debugging": {
    "data": {
      "result": false
    }
  },
  "device_information": {
    "data": {
      "id": "6d963c21-776d-4090-bf7f-fb747e97e281",
      "name": "iPhone 8",
      "os_version": "16.7.10",
      "series": "iPhone",
      "cpu": "A11 Bionic",
      "reset_time": "0001-01-01T00:00:00Z"
    }
  },
  "sim_information": {
    "data": null
  },
  "biometric": {
    "data": {
      "level": "LOW",
      "is_changed": false,
      "is_available": false
    }
  },
  "gps_information": {
    "data": {
      "lat": "0.0",
      "lng": "0.0",
      "is_spoofed": false,
      "distinct": {
        "time": 0,
        "distance": 0
      }
    }
  },
  "linked_devices": {
    "data": [
      {
        "id": "f631a786-11ee-4007-b4c5-1fca41739a85",
        "name": "iPhone 8",
        "os_version": "16.7.10",
        "series": "iPhone",
        "cpu": "A11 Bionic",
        "enrolled_date": "2024-11-26T08:23:35.003756Z",
        "reset_time": "0001-01-01T00:00:00Z"
      }
    ]
  },
  "ip_information": {
    "data": {
      "ip_address": "103.28.116.119",
      "is_vpn": false,
      "geolocation": {
        "lat": -6.5944400000000005,
        "lng": 106.789,
        "country": "Indonesia",
        "prefix": "62",
        "state_province": "West Java",
        "district": "Bogor",
        "city": "Kota Bogor",
        "time_zone": "Asia/Jakarta"
      },
      "asn": {
        "number": 55699,
        "name": "PT. Cemerlang Multimedia"
      },
      "isp": {
        "name": "PT. Cemerlang Multimedia"
      },
      "connection": {
        "type": "Corporate",
        "usage": "business"
      }
    }
  },
  // This feature only active on professional & enterprise only
  "rule_summary": {
    "data": {
      "total_rules_owned": 5,
      "rules_triggered": [
        {
          "rule_name": "rule_default",
          "status": true,
          "severity_level": "normal",
          "action": "allow",
          "reason": "device is trusted and meets all security requirements."
        },
        {
          "rule_name": "rule_otp_spamming",
          "status": false,
          "severity_level": "critical",
          "action": "block",
          "reason": "otp spamming detected"
        }
      ],
      "total_rules_triggered": 2
    }
  }
}
```
## Key Descriptions

### identification

Contains key user identification information.  
**Fields**:
- **trx_id (String)**: Transaction ID for tracking specific transactions.
- **fazpass_id (String)**: Unique Fazpass ID for user identification.
- **scoring (Float)**: Trust score, e.g., 90.0.
- **risk_level (String)**: User risk level, can be `"HIGH"` or `"LOW"`.
- **is_active (Boolean)**: User active status, `true` if active.
- **time_stamp (Long)**: Timestamp in milliseconds.
- **platform (String)**: Platform used, `"android"` or `"ios"`.
- **application (String)**: Application package name, e.g., `"com.fazpass.app"`.

### features

Contains information on device features.  
**Fields**:
- **version (String)**: SDK version used.
- **device_intelligence (Boolean)**: Indicates if device intelligence detection is active.

### root

Detects if the device is rooted.  
**Fields**:
- **result (Boolean)**: `true` if root is detected.

### emulator

Checks if the app is running on an emulator.  
**Fields**:
- **result (Boolean)**: `true` if an emulator is detected.

### tempering

Indicates any system or application tempering.  
**Fields**:
- **result (Boolean)**: `true` if tempering is detected.

### cloning

Detects if the app is a cloned version.  
**Fields**:
- **result (Boolean)**: `true` if the app is a cloned version.

### screen_sharing

Detects if screen sharing is active.  
**Fields**:
- **result (Boolean)**: `true` if screen sharing is detected.

### debugging

Detects if the app is in debug mode.  
**Fields**:
- **result (Boolean)**: `true` if debugging is active.

### device_information

Contains detailed device information.  
**Fields**:
- **id (UUID)**: Unique device ID.
- **name (String)**: Brand name, e.g., `"Samsung"`.
- **os_version (String)**: OS version, e.g., `"Q"`.
- **series (String)**: Device series, e.g., `"A30"`.
- **cpu (String)**: CPU details, e.g., `"Mediatek"`.
- **reset_time (time)**: latest factory reset time of device, e.g., `"2024-10-08T07:31:34Z"`.

### sim_information

SIM card details for the device.  
**Fields**:
- **sim_operator (String)**: SIM operator name.
- **sim_serial (String)**: SIM serial number.

### biometric

Device biometric status.  
**Fields**:
- **level (String)**: Biometric security level, can be `"LOW"` or `"HIGH"`.
- **is_changed (Boolean)**: `true` if biometric status has changed.
- **is_available (Boolean)**: `true` if biometrics are available.

### gps_information

GPS and location data of the device.  
**Fields**:
- **lat (String)**: Latitude of the device.
- **lng (String)**: Longitude of the device.
- **is_spoofed (Boolean)**: `true` if location spoofing is detected.
- **distinct (Object)**:
  - **time (String)**: Time of the location difference.
  - **distance (Float)**: Distance of location change in kilometers.

### linked_devices

Contains information on devices previously linked.  
**Fields**:
- **id (UUID)**: Unique ID of the linked device.
- **name (String)**: Name of the linked device, e.g., `"vivo"`.
- **os_version (String)**: OS version of the linked device.
- **series (String)**: Device series.
- **cpu (String)**: Device CPU details.
- **Enrolled_date (ISO Date)**: Enrollment date of the linked device.

### ip_information

Provides network and IP-based location data.  
**Fields**:
- **ip_address (String)**: IP address of the user.
- **geolocation (Object)**:
  - **lat (Double/Float)**: Latitude of the IP location.
  - **lng (Double/Float)**: Longitude of the IP location.
  - **country (String)**: Country of the IP.
  - **prefix (String)**: IP prefix.
  - **state_province (String)**: State or province of the IP.
  - **district (String)**: District of the IP.
  - **city (String)**: City of the IP.
  - **timeZone (String)**: Time zone of the IP location.
- **asn (Object)**:
  - **number (Integer)**: ASN number.
  - **name (String)**: ASN name.
- **isp (Object)**:
  - **name (String)**: ISP name of the user.
- **connection (Object)**:
  - **type (String)**: Connection type, e.g., `"hosting"`.
  - **usage (String)**: Usage type, e.g., `"consumer"`.

![Logo](/beta/5.jpg)