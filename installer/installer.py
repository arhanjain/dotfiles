from textual import events
from textual.app import App

from widgets import Page

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
        match event.key:
            case i if i in ["enter"]:
                if self.page.page == len(self.page.page_data) - 1:
                    # Finish screen
                    await self.action("quit")
                else:
                    await self.page.key_press(event)
            case _:
                await self.page.key_press(event)
