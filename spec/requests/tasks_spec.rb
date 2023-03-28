require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    subject { get(tasks_path)}
    before { FactoryBot.create_list(:task, task_count) }
    let(:task_count){ 3 }
    it "タスクの一覧が取得できる" do
      # binding.pry
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq task_count
      expect(res[0].keys).to include "title", "description", "due_date", "completed"
      expect(response).to have_http_status(200)
    end
  end
  describe "GET /tasks/:id" do
    subject {get(task_path(task_id))}
    context "指定したIDのタスクが存在する時" do
      let(:task_id){task.id}
      let(:task){create(:task)}
      it "指定したIDのタスクが取得できる" do
        subject
        res = JSON.parse(response.body)
        # binding.pry
        expect(res["title"]).to eq task.title
        expect(res["description"]).to eq task.description
        expect(res["due_date"]).to eq task.due_date.strftime("%FT%T.%LZ")
        expect(res["completed"]).to eq task.completed
        expect(response).to have_http_status(200)
      end
    end
    context "指定したIDのタスクが存在しない時" do
      let(:task_id) do
        Task.last ? Task.last.id + 1 : 1
        # binding.pry
      end
      it "指定したIDのタスクが見つからない" do
        expect{subject}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  describe "POST /tasks" do
    subject{ post(tasks_path, params: params) }
    context "適切なパラメータを送信したとき" do
      let(:params) do
        { task: attributes_for(:task) }
      end
      it "タスクのレコードが作成できる" do
        expect{subject}.to change { Task.count }.by(1)
        res = JSON.parse(response.body)
        # binding.pry
        expect(res["title"]).to eq params[:task][:title]
        expect(res["description"]).to eq params[:task][:description]
        expect(res["due_date"]).to eq params[:task][:due_date].strftime("%FT%T.000Z")
        expect(res["completed"]).to eq params[:task][:completed]
        expect(response).to have_http_status(200)
      end
    end
    context "不適切なパラメータを送信したとき" do
      let(:params) do
        attributes_for(:task)
      end
      it "タスクのレコードが作成できない" do
        # binding.pry
        expect{subject}.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
  describe "PUT/PATCH /task/:id" do
    subject{ patch( task_path(task_id), params: params )}

    let(:params) do
      { task: { title: Faker::Verb.base , created_at: 1.day.ago }}
    end
    let(:task_id){ task.id }
    let(:task){ create(:task) }

    it "指定したIDのタスクに対して更新できる" do
      # binding.pry
      expect { subject }.to change { task.reload.title }.from(task.title).to(params[:task][:title]) & #どう変わるか
      not_change { task.reload.description } & #変わらないこと
      not_change { task.reload.due_date } & #変わらないこと
      not_change { task.reload.completed } & #変わらないこと
      not_change { task.reload.created_at } #変わらないこと
      # binding.pry
    end
  end
  describe "DELETE /task/:id" do
    subject {delete(task_path(task_id))}
    let(:task_id){task.id}
    let!(:task) {create(:task)}

    fit "指定したIDのタスクが削除できる" do
      expect{subject}.to change { Task.count }.by(-1)
    end
  end
end
