$(document).ready(function() {
  var newTaskOnBlur = function() {
    var list = $(this).closest('.list');
    var list_id = list.attr('id').match(/list_(\d+)/)[1];

    var task_name = $('#new_task_name').val();

    if(task_name != '') {
      $.ajax({
        url: '/tasks',
        type: 'post',
        dataType: 'json',
        data: 'task[name]=' + task_name + '&task[list_id]=' + list_id,
        success: function(data, textStatus) {
          var id   = data['task']['id'];
          var name = data['task']['name'];
          $('<li id="task_' + id + '" class="task">' + name + '</li>').replaceAll($('#new_task_name').closest('li')).effect('highlight');
        }
      });
    } else {
      $(this).closest('li').remove();
    }
  };

  var newListOnBlur = function() {
    var list_name = $('#new_list_name').val();

    if(list_name != '') {
      $.ajax({
        url: '/lists',
        type: 'post',
        dataType: 'json',
        data: 'list[name]=' + list_name,
        success: function(data, textStatus) {
          var id   = data['list']['id'];
          var name = data['list']['name'];
          $('<li id="list_' + id + '" class="list"><h2>' + name + '</h2><ul class="tasks"><p><a class="add_task" href="/tasks/new">Add task</a></p></ul></li>').replaceAll($('#new_list_name').closest('li')).effect('highlight');
        }
      });
    } else {
      $(this).closest('li').remove();
    }
  };

  var onTaskListUpdate = function(event, ui) {
    var list = ui.item.closest('.list');
    var list_id = list.attr('id').match(/list_(\d+)/)[1];
    var tasks = list.find('.tasks');

    $.ajax({
      url: '/tasks/reorder',
      type: 'post',
      data: '_method=put&list_id=' + list_id + '&' + tasks.sortable('serialize'),
      success: function(data, textStatus) {
        list.effect('highlight');
      }
    });
  };

  var onTaskHover = function() {
    $('.delete_link', $(this)).show();
  };

  var onTaskBlur = function() {
    $('.delete_link', $(this)).hide();
  };

  $('.add_task').click(function(event) {
    event.preventDefault();
    $(this).closest('.list').find('.tasks').append('<li><input id="new_task_name" type="text" /></li>');
    $('#new_task_name').blur(newTaskOnBlur).focus();
  });

  $('#add_list').click(function(event) {
    event.preventDefault();
    $('#lists').append('<li id="new_list"><input id="new_list_name" type="text" /></li>');
    $('#new_list_name').blur(newListOnBlur).focus();
  });

  $('.task').mouseover(onTaskHover);
  $('.task').mouseout(onTaskBlur);

  // sorting
  $('.list .tasks').sortable({
    axis: 'y',
    tolerance: 'intersect',
    update: onTaskListUpdate
  });
});