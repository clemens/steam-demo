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
  locate_element("list_#{list.id}") { click_link(:class => 'add_task') }
end

module Steam
  module Browser
    class HtmlUnit
      module Actions
        def blur(element, options = {})
          element = locate_element(element) unless element.respond_to?(:xpath)
          page.getFirstByXPath(element.xpath).blur # blur always returns nil
          @page = page.getFirstByXPath(locate_element('body').xpath).click
          respond!
        end
      end
    end
  end
end

When /^I fill in "([^\"]*)" as the new task's name$/ do |name|
  fill_in('new_task_name', :with => name)
  blur(locate_field('new_task_name')) # should actually go to When /^I click somewhere else on the page$/
end

When /^I fill in "([^\"]*)" as the new list's name$/ do |name|
  fill_in('new_list_name', :with => name)
  blur(locate_field('new_list_name')) # should actually go to When /^I click somewhere else on the page$/
end

When /^I click somewhere else on the page$/ do
  # huh?
end

When /^I drag the task "([^\"]*)" above "([^\"]*)"$/ do |task_1_name, task_2_name|
  task_1 = Task.find_by_name(task_1_name)
  task_2 = Task.find_by_name(task_2_name)
  drag_handle = locate_element("task_#{task_1.id}") { locate_element(:class => 'drag') }
  # a little weird: since we limit to sorting on the y-axis, we have to drag one handle "on" the other
  target = locate_element("task_#{task_2.id}") { locate_element(:class => 'drag') }

  drag(drag_handle, :to => target)
end

When /^I drag the task "([^\"]*)" to the list "([^\"]*)"$/ do |task, list|
  task = Task.find_by_name(task)
  list = List.find_by_name(list)
  drag_handle = locate_element("task_#{task.id}") { locate_element(:class => 'drag') }

  drag(drag_handle, :to => "task_#{list.tasks.last.id}")
end

When /^I drag the list "([^\"]*)" above "([^\"]*)"$/ do |list_1_name, list_2_name|
  drag_handle = locate_element(list_1_name) { locate_element(:class => 'drag') }

  drag(drag_handle, :to => list_2_name)
end

When /^I hover the task "([^\"]*)"$/ do |task|
  task = Task.find_by_name(task)
  hover("task_#{task.id}")
end

When /^I hover the list "([^\"]*)"$/ do |list|
  list = List.find_by_name(list)
  hover("list_#{list.id}")
end

When /^I click on the button to delete the task "([^\"]*)"$/ do |task|
  task = Task.find_by_name(task)
  click_link("delete_task_#{task.id}")
end

When /^I click on the button to delete the list "([^\"]*)"$/ do |list|
  list = List.find_by_name(list)
  click_link("delete_list_#{list.id}")
end

When /^I click the link to add a new list$/ do
  click_link('add_list')
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

Then /^the list "([^\"]*)" should be above "([^\"]*)"$/ do |list_1_name, list_2_name|
  # TODO check that list 1 is above list 2 in the DOM
  (List.find_by_name(list_1_name).position < List.find_by_name(list_2_name).position).should be_true
end

Then /^there should not be a task named "([^\"]*)"$/ do |task|
  locate_element(task).should be_nil
  Task.find_by_name(task).should be_nil
end

Then /^there should not be a list named "([^\"]*)"$/ do |list|
  locate_element(list).should be_nil
  List.find_by_name(list).should be_nil
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
