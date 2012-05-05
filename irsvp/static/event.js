var INVITELISTTEMPLATE = '<div class="entry">'
+ '    <span class="delete-entry"><img src="/static/icons/delete-icon.png"/></span>'
+ '    <div class="display">'
+ '        <div class="display-first-line">'
+ '            <div class="invite-last-name"><%= lastName %></div>'
+ '            <div class="invite-first-name"><%= firstName %></div>'
+ '            <div class="invite-responded"><%= (responded === -1 ? "Tentative" : (responded === 0 ? "Declined" : responded + " confirmed")) %></div>'
+ '        </div>'
+ '        <div>'
+ '            <div class="invite-code"><%= code %></div>'
+ '            <div class="invite-email"><%= email %></div>'
+ '        </div>'
+ '        <div class="invite-special"><%= special %></div>'
+ '    </div>'
+ '    <div class="edit">'
+ '        <input class="invite-last-name-input" value="" placeholder="last name"/>'
+ '        <input class="invite-first-name-input" value="" placeholder="first name"/>'
+ '        <input class="invite-email-input" value="" placeholder="email"/>'
+ '        <div class="invite-code"></div>'
+ '        <input class="invite-num-guests-input" value=""/>'
+ '        <input class="invite-responded-input" value=""/>'
+ '        <textarea class="invite-special-input" placeholder="comments and special requests"></textarea>'
+ '        <button class="invite-submit-changes btn primary" type="button">Submit</button>'
+ '        <button class="invite-cancel-changes btn" type="button">Cancel</button>'
+ '    </div>'
+ '</div>';

var inviteList = {
    newInviteIsShown : true,
    Models : { },
    Views : { },
    Collections : { },
    Data : { },
    App : { },
    Templates : { inviteListTemplate : INVITELISTTEMPLATE },
    totalInvited : 0,
    totalConfirmed : 0,
    init : function() {
        return null;
    }
};

inviteList.Models.InviteEntry = Backbone.Model.extend({
    // TODO: Consider adding a model validation method (overriding Backbone's validate method).
    clear : function() {
        this.destroy();
        this.view.remove();
        return null;
    },
    validate : function(model) {
        return model.email.indexOf("@") === -1;
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
        'keypress .edit' : 'keypressHandler',
        'click span.delete-entry' : 'clear',
        'click .invite-submit-changes' : 'saveAndClose',
        'click .invite-cancel-changes' : 'cancel'
    },
    initialize : function() {
        _.bindAll(this, 'render', 'remove');
        this.model.bind('change', this.render, this);
        this.model.bind('destroy', this.remove, this);
        this.model.view = this;
    },
    render : function() {
//        alert("Problem: the JSON model created in saveAndClose needs to have the numeric fields (responded/numGuests) converted to numbers from strings. Look up how to do this.");
        $(this.el).html(this.template(this.model.toJSON()));
        this.updateFields();
        return this;
    },
    close : function() {
        $(this.el).removeClass('editing');
    },
    cancel : function() {
        this.$('.invite-email-input').val(this.model.get('email'));
        this.$('.invite-last-name-input').val(this.model.get('lastName'));
        this.$('.invite-first-name-input').val(this.model.get('firstName'));
        this.$('.invite-responded-input').val(this.model.get('responded'));
        this.$('.invite-num-guests-input').val(this.model.get('numGuests'));
        this.$('.invite-special-input').val(this.model.get('special'));

        this.close();
    },
    saveAndClose : function() {
        var newEmail = this.$('.invite-email-input').val();
        var newLastName = this.$('.invite-last-name-input').val();
        var newFirstName = this.$('.invite-first-name-input').val();

        var oldNumGuests = this.model.get('numGuests');
        var newNumGuests = this.$('.invite-num-guests-input').val();
        var oldResponded = this.model.get('responded');
        var newResponded = this.$('.invite-responded-input').val();

        inviteList.totalInvited += parseInt(newNumGuests) - parseInt(oldNumGuests);
        var oldRespondedForTotal = parseInt(oldResponded) > 0 ? parseInt(oldResponded) : 0;
        var newRespondedForTotal = parseInt(newResponded) > 0 ? parseInt(newResponded) : 0;
        inviteList.totalConfirmed += newRespondedForTotal - oldRespondedForTotal;
        updateInviteCounts();

        var newSpecial = this.$('.invite-special-input').val();
        var newModel = {
            email : newEmail,
            lastName : newLastName,
            firstName : newFirstName,
            responded : newResponded,
            numGuests : newNumGuests,
            special : newSpecial,
        };
        this.model.save(newModel);
        this.close();
    },
    keypressHandler : function(e) {
        if (e.keyCode === 13) {
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
        var numGuests = this.model.get('numGuests');
        var responded = this.model.get('responded');
        var special = this.model.get('special');
        this.$('.invite-email-input').val(email);
        this.$('.invite-last-name-input').val(last);
        this.$('.invite-first-name-input').val(first);
        this.$('.invite-num-guests-input').val(numGuests);
        this.$('.invite-responded-input').val(responded);
        this.$('.invite-special-input').val(special);
    },
    remove : function() {
        $(this.el).remove();
    },
    clear : function() {
        this.model.destroy();
    }
});


inviteList.Views.inviteListAppView = Backbone.View.extend({
    el : '#invitelist-app',
    events : { 
        'keypress #new-invite' : 'appKeypressHandler'
    },
    initialize : function() {
        _.bindAll(this, 'addEntry', 'addAllEntries');
        inviteList.Data.Invites.bind('add', this.addEntry, this);
        inviteList.Data.Invites.bind('reset', this.addAllEntries, this);
        inviteList.Data.Invites.bind('all', this.render, this);
        inviteList.Data.Invites.fetch();
    },
    fillOutRawModel : function() {
        var email = this.$('#new-invite-email').val();
        var lastName = this.$('#new-invite-last-name').val();
        var firstName = this.$('#new-invite-first-name').val();
        var numGuests = this.$('#new-invite-num-guests').val();
        var rawModel = {
            "eventId" : eventId,
            "lastName" : lastName,
            "firstName" : firstName,
            "email" : email,
            "special" : "",
            "responded" : -1,
            "numGuests" : numGuests
            };
        return rawModel;
    },
    clearInputFields : function() {
        this.$('#new-invite-email').val('');
        this.$('#new-invite-last-name').val('');
        this.$('#new-invite-first-name').val('');
        this.$('#new-invite-num-guests').val('');
    },
    createNewEntry : function() {
        var rawModel = this.fillOutRawModel();
        var result = inviteList.Data.Invites.create(rawModel);
        if (result !== false) {
            this.clearInputFields();
	    $('#new-invite-status').hide();
        }
        else {
            $('#new-invite-status').text("Please fix the email address below!");
            $('#new-invite-status').show();
        }
    },
    appKeypressHandler : function(e) {
        if (e.keyCode === 13)
            this.createNewEntry();
    },
    addEntry : function(inviteEntry) {
        var view = new inviteList.Views.InviteEntryView({ model : inviteEntry });
        var parentElement = $('#invite-list');
        parentElement.append(view.render().el);

        if (inviteEntry.get("numGuests") > 0) {
            inviteList.totalInvited += parseInt(inviteEntry.get("numGuests"));
            updateInviteCounts();
        }

        if (inviteEntry.get("responded") > 0) {
            inviteList.totalConfirmed += parseInt(inviteEntry.get("responded"));
            updateInviteCounts();
        }

        return view;
    },
    addAllEntries : function() {
        inviteList.Data.Invites.each(this.addEntry);
    }
});

function toggleNewInviteBox() {
    var buttonText = "";

    if (inviteList.newInviteIsShown) {
        buttonText = "Show";
        $('#invitelist-app').hide();
    } else {
        buttonText = "Hide";
        $('#invitelist-app').show();
    }
    inviteList.newInviteIsShown = !inviteList.newInviteIsShown;
    $('#new-invite-toggle').text(buttonText);
}

function addHandler() {
    inviteList.App.createNewEntry();
}

function cancelHandler() {
    $('#new-invite-email').val('');
    $('#new-invite-first-name').val('');
    $('#new-invite-last-name').val('');
    $('#new-invite-num-guests').val('');
    $('#new-invite-status').hide();
}

inviteList.init = function() {
    inviteList.newInviteIsShown = true;
    $('#new-invite-toggle').click(toggleNewInviteBox);

    $('#cancel').click(cancelHandler);
    $('#add-guest').click(addHandler);

    inviteList.App = new inviteList.Views.inviteListAppView ();
    updateInviteCounts();
}

updateInviteCounts = function() {
    $('#num-invited-and-confirmed').html(
            "<h2>"
            + inviteList.totalInvited.toString()
            + " invited, "
            + inviteList.totalConfirmed.toString()
            + " confirmed" + "</h2>");
}

