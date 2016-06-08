class StudentsController < ApplicationController
  before_action :find_school_student, only: [:edit]

  def index
    @student = Student.find(params[:school_id])
    @school = School.find(@student[:school_id])
    @students = @school.students.all.order(name: :asc)
  end

  def new
    @student = Student.new
  end

  def create
    @school = School.find(params[:school_id])
    @student = @school.students.create(params[:student].permit(:name, :address, :phone, :document, :status))

    respond_to do |format|
      if @student.save
        format.html { redirect_to school_path(@school), notice: "Aluno cadastrado com sucesso." }
        format.json { render :show, status: :created, location: @school }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    @student = Student.find(params[:id])
    @school = @student.school_id

    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to school_students_path(@student), notice: "Dados do aluno atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def student_params
    params.require(:student).permit(:name, :address, :phone, :document, :status)
  end

  def find_school_student
    @student = Student.find(params[:id])
    @school = @student.school_id
  end

end
