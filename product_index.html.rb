<% provide(:title, 'Products' ) %>
<div id="main-products" class="columns is-centered is-sticky-mobile is-sticky-nav">
  <div class="column is-10 is-12-mobile">
    <nav id="control_panel" class="level is-mobile">
      <%= render "control_panel"%>
    </nav>
  </div>
</div>
<div data-controller="search columns is-12">
  <div class="columns is-centered has-margin-top-tiny is-sticky-search">
    <div class="column is-centered is-10-desktop is-10-fullhd is-offset-2-desktop is-offset-2-fullhd is-12-mobile">
      <%= form_with url: products_path, method: :get, data: { type: :json,  action: "ajax:success->search#onSuccess ajax:beforeSend->search#beforePost ajax
                                                                        ajax:error->search#onError" } do |form| %>
      <div class="field has-addons is-expanded is-12-mobile">
        <div class="field-label is-medium has-text-centered is-hidden-mobile">
          <label class="label">Products Search</label>
        </div>
        <div class="field-body">
          <div class="field has-addons has-addons-fullwidth is-centered has-margin-left-tiny has-margin-right-tiny">
            <div class="control">
              <%= form.text_field "search_any",
                                 placeholder:"Find products", class: "input is-medium" %>
            </div>
            <div class="control">
              <%= form.submit "Search", class: "button is-medium is-danger" %>
            </div>
          </div>
        </div>
      </div>
      <% end %>
    </div>
  </div>
  <div id="list-products" class="columns is-centered">
    <div class="column is-four-fifths-desktop is-four-fifths-tablet"  data-controller="infinite-scroll">
      <div class="columns is-centered is-mobile is-multiline has-padding-5" data-target="infinite-scroll.entries search.list">
        <%= render "products" %>
      </div>
      <div data-target="infinite-scroll.pagination search.pagination">
        <%== pagy_bulma_nav(@pagy) %>
      </div>
    </div>
  </div>
</div>
<div id="main-modal" class="modal" data-controller="bulma-modal">
  <div class="modal-background"></div>
  <div class="modal-content">

  </div>
  <button class="modal-close is-large" aria-label="close"></button>
</div>
