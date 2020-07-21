//controller utilizado para buscar mais informações sobre os produtos.

import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ["card"];

    show() {
        if (this.hasCardTarget) {
            this.cardTarget.classList.remove("is-hidden");
        } else {
            fetch(this.data.get("update-url"))
                .then( (r) => r.text())
                .then( (html) => {
                   const fragment = document
                       .createRange()
                       .createContextualFragment(html);
                   this.element.appendChild(fragment);
                });
        }
    }

    hide() {
        if (this.hasCardTarget) {
            this.cardTarget.classList.add("is-hidden");
            let hovercards = document.getElementsByClassName("hovercard")
            for (let hovercard of hovercards) {
                hovercard.classList.add("is-hidden");
            }
        }
    }

    stopShow() {
        this.controller.abort();
    }
}