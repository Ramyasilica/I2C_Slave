# I2C_Slave 

🌍 Welcome World!

Welcome to my eighth GitHub repository 🎉

In this repository, I have implemented an **I2C Slave Write (Slave Receiver)** module using **Verilog HDL**, and its functionality is verified through **simulation waveform analysis**.

This project is focused on understanding how an **I2C slave receives address and data from a master** by following standard I2C timing rules.


📌 What is I2C?

**I2C (Inter-Integrated Circuit)** is a synchronous serial communication protocol that uses two bidirectional lines:

* **SCL** – Serial Clock Line
* **SDA** – Serial Data Line

It follows a **master–slave architecture** and uses **open-drain signaling**, making it widely suitable for on-chip and board-level communication.

##  Project Overview

In this repository, **I have implemented I2C Slave Write only and its working principle**.

The main objective of this project is to:
* Design an I2C slave that **listens to the bus**
* Detect the **slave address**
* Receive **data sent by the master**
* Verify functionality using **simulation waveforms**

This implementation demonstrates how a slave **captures address and data** during a master write operation.

##  I2C Slave Write – Concept

In an **I2C Slave Write (Slave Receiver)** operation:
* The **master controls the SCL clock**
* The **slave monitors SDA**
* The slave samples data on **valid clock edges**
* Address and data are received **serially, MSB first**

The slave responds by acknowledging valid transfers and storing received information internally.


## Signals Used (From Simulation Waveform)

### Control Signals

* `reset_n` – Active-low reset

### I2C Bus Signals

* `scl` – Serial clock from master
* `sda` – Serial data line

### Slave Internal Signals

* `scl_drv` – Slave clock control (when applicable)
* `sda_drv` – Slave data drive (ACK control)
* `address_out[6:0]` – Received slave address
* `data_out[7:0]` – Received data byte

##  Working of the I2C Slave Write Operation

1. Slave comes out of reset and waits for bus activity
2. START condition initiates the I2C transaction
3. Slave samples SDA on rising edges of SCL
4. First 7 bits are captured as the **slave address**
5. Slave acknowledges the address
6. Next 8 bits are captured as **write data**
7. Received data is stored in `data_out`
8. Write operation completes successfully

## 📊 Simulation Results (Waveform Analysis)

From the simulation waveform:
* `scl` is driven externally and sampled correctly
* `sda` follows proper I2C timing behavior
* Slave address **`0x6A`** is decoded successfully
* Data byte **`0xE9`** is received and stored
* SDA drive behavior confirms acknowledgment

✅ Correct address detection
✅ Correct data reception
✅ Proper I2C slave write operation


## 🖼️ Output Waveform

🧾 Conclusion

This repository demonstrates a **working I2C Slave Write (Slave Receiver) implementation** using **Verilog HDL**.

The simulation results verify correct detection of the slave address and successful reception of data from the master, making this project a **reliable and valid I2C slave design**.


### 🙌 Thank you for visiting!

This is my eighth GitHub repository, and it is part of my protocol-based RTL design journey 🚀
More RTL-protocol projects will be added in the future.




