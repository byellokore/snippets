// controller se utiliza do rails remote form eventos 
//são chamados conforme comportament do rails-ujs

import { Controller } from "stimulus";

export default class extends Controller {
    static targets = ["bundle","cart", "quantity"]

    beforePost(event) {
        let quantity = parseInt(this.quantityTarget.value);
        if ( isNaN(quantity) || quantity <= 0 ){
            event.preventDefault();
            alert("Please add quantity!");
            return;
        }
        this.cartTarget.insertAdjacentHTML("afterend", "<progress class='progress is-small is-danger' max='100'>15%</progress>")
        this.quantityTarget.disabled = true;
        let panelInfoElements = document.getElementsByClassName("panel-info");
        for (let panelInfo of panelInfoElements) {
            panelInfo.innerHTML = "<div class='loader-wrapper is-active'><div class='loader is-loading'></div></div>";
        }
    }

    onSuccess(event) {
        let [data, status, xhr] = event.detail;
        this.cartTarget.outerHTML = data.entries;
        document.getElementsByClassName("progress")[0].remove();
        document.getElementById("control_panel").innerHTML = data.panel;
    }

    onError(event) {
        let [data, status, xhr] = event.detail;
    }


}