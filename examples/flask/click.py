#!/usr/bin/env python3
import click

@click.group()
def cli():
    pass

@click.group(help="Ships related comands")
def ships():
    pass

cli.add_command(ships)

@ships.command(help="Sail a ship")
def sail():
    ship_name = "Youp ship"
    print(f"{ship_name} is setting sail")

@ships.command(help="List all of the ships")
def list_ships():
    ships = ["Pitr S", "Dicker O","Shitov D"]
    print(f"Ships: {','.join(ships)}")

@cli.command(help="Talk to sailor")
@click.option("--greeting", default="Hi there", help="Greeting for sailor")
@click.argument("name")
def sailors(greeting, name):
    message = f"{greeting} {name}"
    print(message)

if __name__ == "__main__":
    cli()
