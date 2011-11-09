var INVITELISTTEMPLATE = '<div class="entry">'
+ '    <div class="display">'
+ '        <div class="invite-email"><%= email %></div>'
+ '        <div class="invite-last-name"><%= lastName %></div>'
+ '        <div class="invite-first-name"><%= firstName %></div>'
+ '        <div class="invite-code"><%= code %></div>'
+ '        <div class="invite-responded"><%= responded %></div>'//<% if (responded == 0) { print("<input type=\"checkbox\" disabled/>"); } else if (responded == 1) { print ("<input type=\"checkbox\" checked disabled/>"); } else { print("Declined"); }%></div>'
+ '        <div class="invite-special"></div>'
+ '    </div>'
+ '    <div class="edit">'
+ '        <input class="invite-email-input" value="" placeholder="email"/>'
+ '        <input class="invite-last-name-input" value="" placeholder="last name"/>'
+ '        <input class="invite-first-name-input" value="" placeholder="first name"/>'
+ '        <div class="invite-code"></div>'
+ '        <input class="invite-responded-input" value=""/>'
+ '        <textarea class="invite-special-input" placeholder="comments and special requests"></textarea>'
+ '    </div>'
+ '</div>';

var inviteList = {
    Models : { },
    Views : { },
    Collections : { },
    Data : { },
    App : { },
    Templates : { inviteListTemplate : INVITELISTTEMPLATE },
    init : function() {
        return null;
    }
};

inviteList.Models.InviteEntry = Backbone.Model.extend({
    clear : function() {
        this.destroy();
        this.view.remove();
        return null;
    }
});

inviteList.Collections.InviteCollection = Backbone.Collection.extend({
    model : inviteList.Models.InviteEntry,
    url : '/invite/' + eventId
});

inviteList.Data.Invites = new inviteList.Collections.InviteCollection;

inviteList.Views.InviteEntryView = Backbone.View.extend({
    tagName : 'li',
    template : _.template(inviteList.Templates.inviteListTemplate),
    events : { 
        'dblclick .entry' : 'edit',
        'keypress .edit' : 'keypressHandler'
    },
    initialize : function() {
        _.bindAll(this, 'render', 'remove');
        this.model.bind('change', this.render);
        this.model.bind('destroy', this.remove);
        this.model.view = this;
    },
    render : function() {
        $(this.el).html(this.template(this.model.toJSON()));
        this.updateFields();
        return this;
    },
    close : function() {
        $(this.el).removeClass('editing');
    },
    saveAndClose : function() {
        var newEmail = this.$('.invite-email-input').val();
        var newLastName = this.$('.invite-last-name-input').val();
        var newFirstName = this.$('.invite-first-name-input').val();
        var newResponded = this.$('.invite-responded-input').val();
        var newSpecial = this.$('.invite-special-input').val();
        var newModel = {
            email : newEmail,
            lastName : newLastName,
            firstName : newFirstName,
            responded : newResponded,
            special : newSpecial,
        };
        this.model.save(newModel);
        this.close();
    },
    keypressHandler : function(e) {
        if (e.keyCode == 13) {
            this.saveAndClose();
        }
    },
    edit : function() {
        $(this.el).addClass('editing');
    },
    updateFields : function() {
        var email = this.model.get('email');
        var last = this.model.get('lastName');
        var first = this.model.get('firstName');
        var code = this.model.get('code');
        var email = this.model.get('email');
        var responded = this.model.get('responded');
        var special = this.model.get('special');
        this.$('.invite-email').text(email);
        this.$('.invite-email-input').val(email);
        this.$('.invite-last-name').text(last);
        this.$('.invite-last-name-input').val(last);
        this.$('.invite-first-name').text(first);
        this.$('.invite-first-name-input').val(first);
        this.$('.invite-code').text(code);
        this.$('.invite-responded').text(responded);
        this.$('.invite-responded-input').val(responded);
        this.$('.invite-special').text(special);
        this.$('.invite-special-input').val(special);
    },
    remove : function() {
        $(this.el).remove();
    }
});


inviteList.Views.inviteListAppView = Backbone.View.extend({
    el : $('#invitelist-app'),
    events : {
        "keypress .new-invite" : "appKeypressHandler"
    },
    initialize : function() {
        _.bindAll(this, 'addEntry', 'addAllEntries');
        inviteList.Data.Invites.bind('add', this.addEntry);
        inviteList.Data.Invites.bind('reset', this.addAllEntries);
        inviteList.Data.Invites.bind('all', this.render);
        inviteList.Data.Invites.fetch({ success : function() {
            inviteList.App.addAllEntries();
        } });
    },
    appKeypressHandler : function(e) {

        alert("hells yeah!");
    },
    addEntry : function(inviteEntry) {
        var view = new inviteList.Views.InviteEntryView({ model : inviteEntry });
        var parentElement = $('#invite-list');
        parentElement.append(view.render().el);
    },
    addAllEntries : function() {
        inviteList.Data.Invites.each(this.addEntry);
    }
});

inviteList.init = function() {
    inviteList.App = new inviteList.Views.inviteListAppView ();
}
