var LOGENTRYTEMPLATE = '<div class="entry">' 
+ '    <div class="display">' 
+ '        <div class="log-date"><%= time.year.toString() + "/" + time.month.toString() + "/" + time.day.toString() %></div>' 
+ '        <div class="log-duration"><%= duration %></div>' 
+ '        <div class="log-depth"><%= depth %></div>' 
+ '        <div class="log-location"><%= location %></div>' 
+ '        <div class="log-notes"><%= notes %></div>' 
+ '    </div>' 
+ '    <div class="edit">' 
+ '        <input class="log-date-input" type="text" value=""/>' 
+ '        <input class="log-duration-input" type="text" value=""/>' 
+ '        <input class="log-depth-input" type="text" value=""/>' 
+ '        <input class="log-location-input" type="text" value=""/>' 
+ '        <textarea class="log-notes-input"></textarea>' 
+ '    </div>' 
+ '</div>';




var DiveLog = { Models : {  }
, Views : {  }
, Collections : {  }
, Data : {  }
, App : {  }
, Templates : { LogEntryTemplate : LOGENTRYTEMPLATE }
, init : function () {
    return null;
} };

DiveLog.Models.LogEntry = Backbone.Model.extend({ clear : function () {
    this.destroy();
    this.view.remove();
    return null;
} });

DiveLog.Collections.LogCollection = Backbone.Collection.extend({ model : DiveLog.Models.LogEntry, url : '/log' });

DiveLog.Data.Log = new DiveLog.Collections.LogCollection;

DiveLog.Views.LogEntryView = Backbone.View.extend({ tagName : 'li', template : _.template(DiveLog.Templates.LogEntryTemplate), events : { 'dblclick .entry' : 'edit', 'keypress .edit' : 'handleKeypress' }, initialize : function () {
    _.bindAll(this, 'render');
    this.model.bind('change', this.render);
    this.model.view = this;
    return null;
}, render : function () {
    $(this.el).html(this.template(this.model.toJSON()));
    this.updateFields();
    return this;
}, close : function () {
    $(this.el).removeClass('editing');
    return null;
}, saveAndClose : function () {
    var newDate = this.$('.log-date-input').val();
    var newDuration = this.$('.log-duration-input').val();
    var newDepth = this.$('.log-depth-input').val();
    var newLocation = this.$('.log-location-input').val();
    var newNotes = this.$('.log-notes-input').val();
    var newModel = { date : newDate, duration : newDuration, depth : newDepth, location : newLocation, notes : newNotes };
    this.model.save(newModel);
    this.close();
    return null;
}, handleKeypress : function (e) {
    if (e.keyCode == 13) {
        this.saveAndClose();
    };
    if (e.charCode == 27) {
        this.close();
    };
    return null;
}, edit : function () {
    $(this.el).addClass('editing');
    this.el.focus();
    return null;
}, updateFields : function () {
    var time = this.model.get('time');
    var date = time.year.toString() + '/' + time.month.toString() + '/' + time.day.toString();
    var duration = this.model.get('duration');
    var depth = this.model.get('depth');
    var location = this.model.get('location');
    var notes = this.model.get('notes');
    this.$('.log-date').text(date);
    this.$('.log-date-input').val(date);
    this.$('.log-date-input').datepicker({ dateFormat : 'yy/mm/dd', gotoCurrent : true });
    this.$('.log-duration').text(duration);
    this.$('.log-duration-input').val(duration);
    this.$('.log-depth').text(depth);
    this.$('.log-depth-input').val(depth);
    this.$('.log-location').text(location);
    this.$('.log-location-input').val(location);
    this.$('.log-notes').text(notes);
    this.$('.log-notes-input').val(notes);
    return null;
}, remove : function () {
    $(this.el).remove();
    return null;
} });

DiveLog.Views.LogAppView = Backbone.View.extend({ el : $('#divelog-app'), initialize : function () {
    _.bindAll(this, 'addEntry', 'addAllEntries', 'render');
    DiveLog.Data.Log.bind('add', this.addEntry);
    DiveLog.Data.Log.bind('reset', this.addAllEntries);
    DiveLog.Data.Log.bind('all', this.render);
    return DiveLog.Data.Log.fetch({ success : function () {
        DiveLog.App.addAllEntries();
        return null;
    } });
}, addEntry : function (logEntry) {
    var view = new DiveLog.Views.LogEntryView({ model : logEntry });
    var parentElement = $('#log-list');
    parentElement.append(view.render().el);
    return null;
}, addAllEntries : function () {
    DiveLog.Data.Log.each(this.addEntry);
    return null;
} });

DiveLog.init = function () {
    $('.date-widget').datepicker({ dateFormat : 'yy/mm/dd' });
    DiveLog.App = new DiveLog.Views.LogAppView();
    return null;
};
