import pyttsx3



def text2voice():
    engine = pyttsx3.init()

    print(dir(engine))

    rate = engine.getProperty('rate')
    engine.setProperty('rate', rate-60)

    volume = engine.getProperty('volume')
    engine.setProperty('volume', volume-0.25)
    engine.setProperty('pitch', 1.2)

    engine.setProperty('voice', "russian")
    engine.say("Привет! Сенис!")

    try:
        engine.runAndWait()
    except KeyboardInterrupt:
        engine.stop()


if __name__ == "__main__":
    text2voice()
