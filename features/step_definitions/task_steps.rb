When /^I click on "([^\"]*)"$/ do |text|
  click_on(text)
end


Given /^the following tasks:$/ do |tasks|
  tasks.hashes.each do |attributes|
    list = List.find_or_create_by_name(attributes['list'])
    Task.create!(:name => attributes['name'], :list => list)
  end
end

Given /^the task "([^\"]*)" is marked as (done|open)$/ do |task, status|
  Task.find_by_name(task).update_attribute(:done, status == 'open' ? false : true)
end

When /^I click the link to add a new task to the list "([^\"]*)"$/ do |list|
  list = List.find_by_name(list)
  click_link("list_#{list.id}_add_task")
end

When /^I fill in "([^\"]*)" as the new task's name$/ do |name|
  fill_in('new_task_name', :with => name)
end

When /^I fill in "([^\"]*)" as the task's name$/ do |name|
  fill_in('task[name]', :with => name)
end

When /^I click somewhere else on the page$/ do
  blur(page.getFocusedElement)
end

When /^I drag the task "([^\"]*)" above "([^\"]*)"$/ do |task_1_name, task_2_name|
  task_1 = Task.find_by_name(task_1_name)
  task_2 = Task.find_by_name(task_2_name)
  drag_handle = locate_element("task_#{task_1.id}") { locate_element(:class => 'drag') }
  # a little weird: since we limit to sorting on the y-axis, we have to drag one handle "on" the other
  target = locate_element("task_#{task_2.id}") { locate_element(:class => 'drag') }

  drag_and_drop(drag_handle, :to => target)
end

When /^I drag the task "([^\"]*)" to the list "([^\"]*)"$/ do |task, list|
  task = Task.find_by_name(task)
  list = List.find_by_name(list)
  drag_handle = locate_element("task_#{task.id}") { locate_element(:class => 'drag') }

  drag_and_drop(drag_handle, :to => "task_#{list.tasks.last.id}")
end

When /^I hover the task "([^\"]*)"$/ do |task|
  task = Task.find_by_name(task)
  hover("task_#{task.id}")
end

When /^I click on the button to delete the task "([^\"]*)"$/ do |task|
  task = Task.find_by_name(task)
  click_link("delete_task_#{task.id}")
end

When /^I (check|uncheck) the task "([^\"]*)"$/ do |action, task|
  task = Task.find_by_name(task)
  send(action, "task_#{task.id}_done")
end

Then /^there should be a task named "([^\"]*)" in the list "([^\"]*)"$/ do |task, list|
  list = List.find_by_name(list)
  task = Task.find_by_name(task)

  locate_element("list_#{list.id}") do
    locate_element("task_#{task.id}").should_not be_nil
  end
  list.tasks.should include(task)
end

Then /^the task "([^\"]*)" should be above "([^\"]*)"$/ do |task_1_name, task_2_name|
  # TODO check that task 1 is above task 2 in the DOM
  (Task.find_by_name(task_1_name).position < Task.find_by_name(task_2_name).position).should be_true
end

Then /^there should be a task named "([^\"]*)"$/ do |task|
  locate_element(task).should_not be_nil
  Task.find_by_name(task).should_not be_nil
end

Then /^there should not be a task named "([^\"]*)"$/ do |task|
  locate_element(task).should be_nil
  Task.find_by_name(task).should be_nil
end

Then /^there should be a list named "([^\"]*)"$/ do |list|
  list = List.find_by_name(list)

  list.should_not be_nil
  locate_element("list_#{list.id}").should_not be_nil
end

Then /^the task "([^\"]*)" should be marked as (done|open)$/ do |task, state|
  task = Task.find_by_name(task)
  task.send(:"#{state}?").should be_true
end
