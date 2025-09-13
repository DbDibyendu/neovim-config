import time

import pyautogui


def prevent_sleep(interval=30):
    print("Preventing sleep... Press Ctrl+C to stop.")
    while True:
        pyautogui.move(1, 0, duration=0.1)
        pyautogui.move(-1, 0, duration=0.1)
        time.sleep(interval)


if __name__ == "__main__":
    prevent_sleep()
