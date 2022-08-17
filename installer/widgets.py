import utils
import os, stat, subprocess, shutil
import requests


from pathlib import Path
from collections import deque
from rich.text import Text
from typing import List
from rich import box
from rich.align import Align
from rich.table import Table
from rich.panel import Panel
from rich.layout import Layout
from rich.padding import Padding
from textual import events
from textual.reactive import Reactive
from textual.widget import Widget

class Page(Widget):

    selected = Reactive(0)
    page = Reactive(0)
    page_type = Reactive("start")

    def __init__(self, page_data: dict):
        super().__init__()
        self.page_data = page_data
        self.log_text = deque()

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

    def make_selection_panel(self):
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
        info = self.options[self.selected]["info"] 
        table.add_row(
            info,
            style="yellow"
        )

        # Formatting
        table = Align.center(table, vertical="middle")
        table = Padding(table, (2, 3))
        panel = Panel(
                    table,
                    box=box.ROUNDED,
                    title="Guide",
                    border_style="blue",
                    expand=True
                )
        panel = Align.center(panel, vertical="middle")
        return panel


    def make_log_panel(self):
        text = Text()

        for entry in self.log_text:
            text.append(f"{entry}\n")

        panel = Panel(
            text,
            box=box.ROUNDED,
            title="Log",
            border_style="blue",
            expand=False,
        )
        return panel

    def make_page(self):
        self.update_page_attributes()
        # Log Panel

        # Make pages
        selection_panel = self.make_selection_panel()

        layout = Layout()
        layout.split_row(
            Padding(selection_panel, (1,2)),
        )

        page = Panel(
                layout,
                box=box.ROUNDED,
                title="Arhan Jain's Dotfiles Installer",
                border_style="magenta",
        )

        return page

    def exec_command(self):
        command_str = self.options[self.selected]["command"]
        if command_str is not None:
            installer_dir = Path(__file__).parent
            command = getattr(utils, command_str)
            command(installer_dir=installer_dir)
            

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
                else:
                    # Custom Installation screen
                    self.exec_command()
                    self.selected = 0
                    self.page += 1




