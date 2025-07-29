# Frogger Game on DE1-SoC

This project implements a simple Frogger-style game where the player controls a frog trying to cross a highway without getting hit by cars.

## Controls

The frog can be moved using the following keys:

- **KEY0**: Right  
- **KEY1**: Up  
- **KEY2**: Down  
- **KEY3**: Left  

You can reset the game at any time using **SW9**.

## Gameplay

- Reach the top of the screen to **increase your score by 1**.
- Avoid the cars — **each hit costs one life**.
- You start with **3 lives**.
- The game ends when all lives are lost.

## Display

- The **right side** of the screen shows your **score**.
- The **left side** of the screen shows your **remaining lives**.

## Project Setup

- Set `DE1_SoC.sv` as the **top-level entity** in your Quartus project.
- Ensure all key and switch pin assignments match your board configuration.


