/**
 * Класс для работы со справочниками в лайтбоксе
 *
 **/
function Reference(options) {
  var
    _self = this,
    _default = {
      callback: {},
      dialog: {
        modal: true,
        height: 'auto',
        width: 'auto',
        autoOpen: false,
        title: 'Поиск в справочнике',
        buttons: [{
          text: function() { return _options.captionOK; }, 
          click: function() {
            var $selected = _$container.find('.js-reference-result').find('.' + _options.classSelected);
            if ($selected.length) {
              _options.callback.ok && _options.callback.ok($selected);
              _self.close();
            }
          },
          disabled: true
        }, {
          text: function() { return _options.captionCancel; },
          click: function() {
            _options.callback.close && _options.callback.close();
            _self.close();
          }
        }]
      },
      ajax: {
        url: '',
        data: {q: function() {
          return _$container.find('.js-reference-input').val();
        }},
        dataType: 'html',
        success: function(response) {
          _$container.find('.js-reference-result').html(response);
        },
        beforeSend: function() {
          _$container.find('.js-reference-button, .js-reference-input').addClass(_options.classLoader).prop('disabled', true);  
        },
        complete: function() {
          _$container.find('.js-reference-button, .js-reference-input').removeClass(_options.classLoader).prop('disabled', false);  
        }
      },
      captionButton: 'Найти',
      captionOK: 'OK',
      captionCancel: 'Отмена',
      classContainer: 'reference-container',
      classInput: 'reference-input',
      classButton: 'reference-button',
      classResult: 'reference-result',
      classLoader: 'reference-loader',
      classSelected: 'reference-selected-row'
    },
    _options = $.extend(true, _default, options),
    _$container = $('<div>')
      .addClass(_options.classContainer + ' js-reference-container')
      .append(
        $('<input type="text">')
          .addClass(_options.classInput + ' js-reference-input')
          .on('propertychange input change keyup', _change)
          .keypress(function(event) {
            if (event.which == 13) {
              _find();
            }
          }),  
        $('<button type="button">')
          .addClass(_options.classButton + ' js-reference-button')
          .text(_options.captionButton)
          .prop('disabled', true)
          .click(_find),
        $('<div>')
          .addClass(_options.classResult + ' js-reference-result')
          .on('click', '*', function(e) {
            var $selected = $(this);
            if (!$selected.data('id')) {
              $selected = $(this).closest('[data-id]');
            }
            if ($selected.length) {
              $selected.addClass(_options.classSelected);            
              $('.ui-dialog-buttonpane button:contains(' + _options.captionOK + ')', _$container.parent()).button('enable');
              _options.callback.ok && _options.callback.ok($selected);
              _self.close();
            }
          })
      )
      .hide();

  // поиск
  function _find() {
    if (!_$container.find('.js-reference-input').val()) {
      return false;
    }
    $('.ui-dialog-buttonpane button:contains(' + _options.captionOK + ')', _$container.parent()).button('disable');
    $.ajax(_options.ajax);
  }

  function _change() {
    _$container.find('.js-reference-button').prop('disabled', !_$container.find('.js-reference-input').val());
  }

  this.open = function() {
    _$container.dialog('open');        
  }

  this.close = function() {
    _$container.dialog('close');        
  }

  _$container.dialog(_options.dialog);
}


// инициализатор всех справочников по data-reference-url
$(document).ready(function() {
  $('[data-reference-url]').each(function(index) {
    var
      $this = $(this),
      ref = new Reference({
        dialog: {
          title: $(this).data('reference-title')
        },
        ajax: {
          url: $this.data('reference-url')
        },
        callback: {
          ok: function($selected) {
            $($this.data('reference-selector-id')).val($selected.data('id'));
            $($this.data('reference-selector-text')).val($selected.data('text'));
          }
        }
      });

    $this.click(function() {
      ref.open();
    });
  });
});