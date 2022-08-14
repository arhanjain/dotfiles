import json
from os import wait
import os

from typing import List
from rich import box
from rich.align import Align
from rich.table import Table
from rich.panel import Panel
from rich.padding import Padding
from rich.console import Group
from textual import events
from textual.reactive import Reactive
from textual.app import App
from textual.widget import Widget

class Page(Widget):

    selected = Reactive(0)
    page = Reactive(0)
    page_type = Reactive("start")

    def __init__(self, page_data: dict):
        super().__init__()
        self.page_data = page_data

    def render(self):
        return self.make_page()

    def update_page_attributes(self):
        page_attributes = self.page_data[self.page]
        self.title = page_attributes["title"]
        self.options = page_attributes["options"]

    def option_styles(self) -> List[str]:
        styles = [ "white" for i in range(2) ]
        styles[int(self.selected)] = "blue bold "
        return styles

    def make_page(self):
        self.update_page_attributes()
        option_styles = self.option_styles()

        table = Table.grid(padding=1) 
        table.add_column(max_width=40)

        # Title
        table.add_row(
            self.title,
            style="green bold",
        )
        
        # Options
        for i, (option) in enumerate(self.options):
            table.add_row(
                option["text"],
                style=option_styles[i]
            )

        # Note
        table.add_row(
            self.options[self.selected]["info"],
            style="yellow"
        )

        # Formatting
        table = Align.center(table, vertical="middle")
        table = Padding(table, (1, 2))
        panel = Panel(
                    table,
                    box=box.ROUNDED,
                    title="Arhan Jain's Dotfiles Installer",
                    border_style="red",
                    expand=False
                )

        panel = Align.center(panel, vertical="middle")

        return panel

    def exec_command(self):
        command = self.options[self.selected]["command"]
        if command is not None:
            installer_dir = os.path.dirname(__file__)
            util_script = os.path.join(installer_dir, "utils.sh")
            os.system(f"{util_script} {command}")

    async def key_press(self, event: events.Key) -> None:
        match event.key:
            case i if i in ["j"]:
                if self.selected < len(self.options) - 1:
                    self.selected += 1
            case i if i in ["k"]:
                if self.selected > 0:
                    self.selected -= 1
            case i if i in ["enter"]:
                if self.page == 0:
                    # Start Screen
                    match self.selected:
                        case 0:  # Default installation
                            pass
                        case 1:  # Custom installation
                            self.selected = 0
                            self.page += 1
                elif self.page == len(self.page_data) - 1:
                    # Finish Screen
                    #exit program
                    pass
                else:
                    # Custom Installation screen
                    self.exec_command()
                    self.selected = 0
                    self.page += 1
                        #execute command

class Installer(App):

    def __init__(self, config: dict, screen: bool = True, driver_class: None = None, log: str = "", log_verbosity: int = 1, title: str = "Textual Application"):
        super().__init__(screen, driver_class, log, log_verbosity, title)
#        super().__init__()
        self.config = config

    async def on_mount(self) -> None:
        self.page = Page(page_data=self.config["pages"])
        await self.view.dock(self.page)

    async def on_load(self, event):
        await self.bind("q", "quit")

    async def on_key(self, event: events.Key) -> None:
        await self.page.key_press(event)


if __name__ == "__main__":

    config_file_path = f"{os.path.dirname(__file__)}/installer.json"
    config_file = open(config_file_path, "r")
    config = json.load(config_file)
    config_file.close()

    Installer.run(config=config)

