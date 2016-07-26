// Copyright © Mapotempo, 2016
//
// This file is part of Mapotempo.
//
// Mapotempo is free software. You can redistribute it and/or
// modify since you respect the terms of the GNU Affero General
// Public License as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Mapotempo is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Mapotempo. If not, see:
// <http://www.gnu.org/licenses/agpl.html>
//
PNotify.prototype.options.styling = 'fontawesome';

(function() {
  function notify(status, message, options) {
    new PNotify($.extend({
      text: message,
      type: status,
      animation: 'slide',
      animate_speed: 'normal',
      shadow: true,
      hide: true,
      buttons: {
        sticker: false,
        closer: true
      }
    }, options));
  };

  function desktop_notify(status, message, options) {
    PNotify.desktop.permission();
    notify(status, message, $.extend({
      title: reseller_name,
      desktop: {
        desktop: true
      }
    }, options));
  };

  $.extend(window, {
    notify: function(status, message, options) {
      notify(status, message, $.extend({}, options));
    },
    stickyNotice: function(message, options) {
      notify('success', message, $.extend(options, {
        hide: false
      }));
    },
    notice: function(message, options) {
      notify('success', message, options);
    },
    desktopNotice: function(message, options) {
      desktop_notify('success', message, $.extend({}, options));
    },
    stickyError: function(message, options) {
      notify('error', message, $.extend(options, {
        hide: false
      }));
    },
    error: function(message, options) {
      notify('error', message, options);
    },
    desktopError: function(message, options) {
      desktop_notify('error', message, $.extend({}, options));
    },
    hideNotices: function() {
      PNotify.removeAll();
    }
  });
})();
