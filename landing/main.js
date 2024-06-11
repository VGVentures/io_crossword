const accordionButtons = document.getElementsByClassName("accordion-button");
const panels = document.getElementsByClassName("panel");

const close = (element) => {
  element.classList.remove("open");
  element.classList.add("closed");
};

const toggle = (element) => {
  if (element.classList.contains("open")) {
    element.classList.remove("open");
    element.classList.add("closed");
  } else {
    element.classList.remove("closed");
    element.classList.add("open");
  }
};

for (let i = 0; i < accordionButtons.length; i++) {
  accordionButtons[i].addEventListener("click", function () {
    const panel = this.nextElementSibling;

    // closes all panels but not the current one
    for (let i = 0; i < panels.length; i++) {
      if (accordionButtons[i] !== this) {
        close(accordionButtons[i]);
      }

      if (panels[i] !== this.nextElementSibling) {
        close(panels[i]);
      }
    }

    toggle(panel);
    toggle(this);
  });
}
