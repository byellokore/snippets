// controller para infinite scroll dos produtos na página 

import { Controller } from "stimulus";
import Rails from "@rails/ujs";
import {dom} from "@fortawesome/fontawesome-svg-core";
export default class extends Controller {
    static targets = ["entries", "pagination"]

    initialize() {
        let options = {
            rootMargin: '10px',
            threshold: 0.1
        }
        this.intersectionObserver = new IntersectionObserver(entries => this.processIntersectionEntries(entries), options);
    }

    connect() {
        this.intersectionObserver.observe(this.paginationTarget);
    }

    disconnect() {
        this.intersectionObserver.unobserve(this.paginationTarget);
    }

    processIntersectionEntries(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                this.loadMore();
            }
        });
    }

    loadMore() {
        let next_page = this.paginationTarget.querySelector("a[rel='next']")
        if (next_page == null) { return; }
        let url = next_page.href

        Rails.ajax({
            type: 'GET',
            url: url,
            dataType: 'json',
            success: (data) => {
                this.entriesTarget.insertAdjacentHTML('beforeend', data.entries);
                this.paginationTarget.innerHTML =  data.pagination;
                dom.i2svg();
            }
        })
    }
}