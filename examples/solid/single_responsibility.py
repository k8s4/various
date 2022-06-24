class FormatData:
    def __init__(self, raw_data):
        self.raw_data = raw_data

    def prepare(self):
        result = ""
        for item in self.raw_data:
            new_line = ",".join(
                    (
                        item["firsname"],
                        item["lastname"],
                        item["profession"]
                    )
            )
            result += f"{new_line}\n"
        return result

class FileWriter:
    def __init__(self, filename):
        self.filename = filename

    def write(self, data):
        with open(self.filename, "w", encoding="UTF8") as f:
            f.write(data)

data = [
        { 
            "firsname":"Vasiliy",
            "lastname":"Pupkin",
            "profession":"Engineer"
        },
        { 
            "firsname":"Ivan",
            "lastname":"Dovlatov",
            "profession":"Shoppist"
        },
]

formater = FormatData(data)
formatted_data = formater.prepare()

writer = FileWriter("test.csv")
writer.write(formatted_data)

