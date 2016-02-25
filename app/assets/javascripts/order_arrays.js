// Copyright © Mapotempo, 2014-2015
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
var order_arrays_form = function() {
  $('#order_array_base_date').datepicker({
    language: defaultLocale,
    autoclose: true,
    calendarWeeks: true,
    todayHighlight: true
  });
}

var order_arrays_new = function(params) {
  order_arrays_form();
}

var order_arrays_edit = function(params) {
  var order_array_id = params.order_array_id,
    planning_id = params.planning_id,
    block_save_select_change = false,
    table_neeed_update = true;

  order_arrays_form();

  var filter_text = function(exactText, normalizedValue, filter, index) {
    return !!String(normalizedValue).match(new RegExp(filter, 'i'));
  }

  var formatNoMatches = I18n.t('web.select2.empty_result');

  var select2_build_options = function(products, product_ids) {
    var data_products = [];
    $.each(products, function(i, product) {
      data_products.push({
        id: product.id + '.' + product_ids.length,
        text: product.code,
        code: product.code
      });
    });
    $.each(product_ids, function(i, product_id) {
      data_products.push({
        id: product_id + '.' + i,
        text: products[product_id].code,
        code: products[product_id].code,
        active: true
      });
    });
    return data_products;
  }

  var set_fake_select2 = function(products, selector, shift) {
    fake_select2(selector, function(select) {
      var data = $.map(select[0].options || [], function(option) {
        return {
          id: option.value,
          text: option.label
        };
      });

      select.select2({
        theme: 'bootstrap',
        data: data,
        minimumResultsForSearch: -1,
        formatNoMatches: function() {
          return formatNoMatches;
        },
        width: '100%'
      });
      select.next('.select2-container--bootstrap').addClass('input-sm');

      select.change(function(e) {
        if (block_save_select_change) {
          return;
        }

        table_neeed_update = true;
        build_total(undefined, $('#order_array table'), shift);

        var id = select.parent().data('id');
        var product_ids = $.map(select.val() || [], function(val, i) {
          return val.split('.')[0];
        });
        $.ajax({
          type: "put",
          data: {
            product_ids: product_ids
          },
          url: '/api/0.1/order_arrays/' + order_array_id + '/orders/' + id + '.json',
          beforeSend: beforeSendWaiting,
          complete: completeWaiting,
          success: function() {
            select.select2('close');
          },
          error: ajaxError
        });

        select.find('option:not(:selected)').remove();
        $.each(products, function(i, product) {
          select.append('<option value="' + product.id + '.' + product_ids.length + '">' + product.code + '</option>');
        });
      });
    });
  }

  var build_fake_select2 = function(container, products, product_ids) {
    return container.html(SMT['order_arrays/fake_select2']({
      products: select2_build_options(products, product_ids)
    }));
  }

  var build_total = function(e, table, shift) {
    var $table = $(table),
      sum_column = [],
      grand_total = {};

    $('tbody tr', $table).each(function(i, tr) {
      var $tr = $(tr),
        sum_row = {},
        total = 0;
      $('td[data-id] select', $tr).each(function(j, select) {
        var vals = $.map($(select).val() || [], function(val, i) {
          return val.split('.')[0];
        });
        if (vals) {
          if (!sum_column[j]) {
            sum_column[j] = {
              undefined: 0
            };
          }
          $.each(vals, function(i, val) {
            sum_row[val] = (sum_row[val] || 0) + 1;
            sum_column[j][val] = (sum_column[j][val] || 0) + 1;
          });
        }
      });
      $('td[data-sum-product-id]', $tr).each(function(i, td) {
        var pid = $(td).data('sum-product-id');
        td.innerHTML = sum_row[pid] || '-';
        grand_total[pid] = (grand_total[pid] || 0) + (sum_row[pid] || 0);
        total += sum_row[pid] || 0;
      });
      $('td.total-products', $tr).html(total || '-');
    });

    // Columns
    var product_length = $('tfoot tr').length - 1;
    var row_length = $('thead:not(.tablesorter-stickyHeader) tr:first .order', $table).length;
    grand_total[undefined] = 0;
    $('tfoot tr').each(function(i, tr) {
      var $tr = $(tr),
        pid = $('th[data-product_id]', $tr).data('product_id');
      $('td:nth-child(n+4)', $(tr)).each(function(j, td) {
        sum_column[j] = sum_column[j] || {};
        td.innerHTML = sum_column[j] && sum_column[j][pid] || '-';
        sum_column[j][undefined] += sum_column[j][pid] || 0;
      });
      $('td:nth-child(' + (row_length + 4 + shift + i) + ')', $tr).html(grand_total[pid] || '-');
      grand_total[undefined] += grand_total[pid] || 0;
    });

    table_trigger_update();
  }

  var table_trigger_update = function() {
    if (table_neeed_update) {
      table_neeed_update = false;
      $("#order_array table").trigger("update");
    }
  }

  var products = {};

  var display_order_array = function(data) {
    var container = $('#order_array div');
    $.each(data.products, function(i, product) {
      products[product.id] = product;
    });
    $.each(data.rows, function(i, row) {
      $.each(row.orders, function(i, order) {
        order.products = select2_build_options(products, order.product_ids)
      });
    });
    data.i18n = mustache_i18n;
    $(container).html(SMT['order_arrays/edit'](data));

    var false_formater = function($cell, indx) {
      return false;
    };
    var no_sorter = {
      sorter: false
    };

    var headers = {
      0 : no_sorter
    };
    var filter_formatter = {
      0: false_formater
    };

    var shift = 0;
    if (planning_id) {
      shift = 2;
      headers[1] = no_sorter;
      filter_formatter[1] = false_formater;
    }

    var filter_functions = {};
    for (var i = 0; i < data.columns.length; i++) {
      headers[i + 3 + shift] = no_sorter;
      filter_functions[i + 3 + shift] = filter_text;
    }
    for (var i = 0; i < data.products.length + 1; i++) {
      filter_formatter[i + data.columns.length + 3 + shift] = false_formater;
    }

    $("#order_array table").bind("tablesorter-initialized", function(e, table) { build_total(e, table, shift); }).tablesorter({
      textExtraction: function(node, table, cellIndex) {
        if (cellIndex >= 3 + shift && cellIndex < data.columns.length + 3 + shift) {
          return $.map($("[name$=\\[product_ids\\]\\[\\]] :selected", node), function(e, i) {
            return e.text;
          }).join(",");
        } else {
          return $(node).text();
        }
      },
      headers: headers,
      theme: "bootstrap",
      // Show order icon v and ^
      headerTemplate: '{content} {icon}',
      widgets: ["uitheme", "stickyHeaders", "filter", "columnSelector"],
      widgetOptions: {
        filter_childRows: true,
        // class name applied to filter row and each input
        filter_cssFilter: "tablesorter-filter",
        filter_functions: filter_functions,
        filter_formatter: filter_formatter
      }
    });

    // Workaround rowspan and tablesorter-filter
    $('.tablesorter-filter-row td:last-child').remove();
    for (var i = 0; i < data.products.length; i++) {
      $('.tablesorter-filter-row td:last-child').remove();
    }

    $('#order_array table thead input').focusin(table_trigger_update);
    $('#order_array table thead .tablesorter-icon').click(table_trigger_update);

    set_fake_select2(products, $('td[data-id] select'), shift);

    var change_order = function(product_id, add_product, remove_product, paste, copy, selector_function) {
      var orders = {};
      block_save_select_change = true;
      selector_function().each(function(i, select) {
        var $select = $(select),
          $td = $select.parent();
        var val = [];
        if (add_product || remove_product) {
          val = $.map($select.val() || [], function(v, i) {
            return v.split('.')[0];
          });
          var index = val.indexOf(product_id);
          if (add_product) {
            val.push(product_id);
          } else if (remove_product) {
            if (index >= 0) {
              val.splice(index, 1);
            }
          }
        } else if (paste && copy) {
          val = $.map(copy[i] || [], function(v, i) {
            return v.split('.')[0];
          });
        }
        build_fake_select2($td, products, val);

        orders[$td.data('id')] = {
          product_ids: val
        };
      });
      set_fake_select2(products, selector_function(), shift);
      block_save_select_change = false;
      table_neeed_update = true;
      build_total(undefined, $('#order_array table'), shift);

      $.ajax({
        type: "patch",
        data: JSON.stringify({
          orders: orders
        }),
        contentType: "application/json",
        url: '/api/0.1/order_arrays/' + order_array_id + '.json',
        beforeSend: beforeSendWaiting,
        complete: completeWaiting,
        error: ajaxError
      });
    }

    var copy_row;
    $('.copy_row').click(function(e) {
      var tr = $(this).closest('tr');
      copy_row = [];
      $.each($('td[data-id] select', tr), function(i, select) {
        copy_row.push($.map($(select).val() || [], function(n) {
          return n.toString();
        }));
      });
    });

    $('.empty_row, .paste_row, .add_product_row, .remove_product_row').click(function(e) {
      if (confirm(I18n.t('order_arrays.edit.confirm_ovewrite_row'))) {
        var tr = $(this).closest('tr'),
          add_product = $(this).hasClass('add_product_row'),
          remove_product = $(this).hasClass('remove_product_row'),
          paste = $(this).hasClass('paste_row'),
          product_id = ($(this).data('product_id') || 0).toString(),
          selector_function = function() {
            return $('td[data-id] select', tr);
          };
        change_order(product_id, add_product, remove_product, paste, copy_row, selector_function);
      }
    });

    var copy_column;
    $('.copy_column').click(function(e) {
      var td_index = $(this).closest('th').index('th') + 1;
      copy_column = [];
      $('tbody tr td:nth-child(' + td_index + ') select', $(this).closest('table')).each(function(i, select) {
        copy_column.push($.map($(select).val() || [], function(n) {
          return n.toString();
        }));
      });
    });

    $('.empty_column, .paste_column, .add_product_column, .remove_product_column').click(function(e) {
      if (confirm(I18n.t('order_arrays.edit.confirm_ovewrite_column'))) {
        var $this = $(this),
          td_index = $this.closest('th').index('th') + 1,
          add_product = $this.hasClass('add_product_column'),
          remove_product = $this.hasClass('remove_product_column'),
          paste = $this.hasClass('paste_column'),
          product_id = ($this.data('product_id') || 0).toString(),
          selector_function = function() {
            return $('tbody tr td:nth-child(' + td_index + ') select', $this.closest('table'));
          };
        change_order(product_id, add_product, remove_product, paste, copy_column, selector_function);
      }
    });

    $('.planning').click(function(e) {
      var index = $(this).closest('th').index('th') - 3,
        planning_id = $(this).data('planning_id').toString();
      $.ajax({
        type: "patch",
        contentType: "application/json",
        url: '/api/0.1/plannings/' + planning_id + '/orders/' + order_array_id + '/' + index + '.json',
        beforeSend: beforeSendWaiting,
        success: function() {
          window.location = '/plannings/' + planning_id +'/edit';
        },
        complete: completeWaiting,
        error: ajaxError
      });
    });
  }

  $("#dialog-loading").dialog({
    autoOpen: true,
    modal: true
  });

  $.ajax({
    url: '/order_arrays/' + order_array_id + '.json' + (planning_id ? '?planning_id=' + planning_id : ''),
    beforeSend: beforeSendWaiting,
    success: display_order_array,
    complete: function(data) {
      completeWaiting(data);
      $("#dialog-loading").dialog('close');
    },
    error: ajaxError
  });
}

Paloma.controller('OrderArray').prototype.new = function() {
  order_arrays_new(this.params);
};

Paloma.controller('OrderArray').prototype.create = function() {
  order_arrays_new(this.params);
};

Paloma.controller('OrderArray').prototype.edit = function() {
  order_arrays_edit(this.params);
};

Paloma.controller('OrderArray').prototype.update = function() {
  order_arrays_edit(this.params);
};
