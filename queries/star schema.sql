CREATE TABLE IF NOT EXISTS DimProgram (
    ProgramID STRING PRIMARY KEY,
    ProgramName STRING,
    Department STRING
) USING DELTA;

CREATE TABLE IF NOT EXISTS DimStudent (
    StudentID STRING PRIMARY KEY,
    Gender STRING,
    ProgramID STRING REFERENCES DimProgram(ProgramID)
) USING DELTA;

CREATE TABLE IF NOT EXISTS DimCourse (
    CourseID STRING PRIMARY KEY,
    CourseName STRING,
    Department STRING,
    Type STRING,
    Semester STRING,
    YearLevel STRING,
    ProgramID STRING
) USING DELTA;


CREATE TABLE IF NOT EXISTS FactEnrollment (
    EnrollmentID STRING PRIMARY KEY,
    StudentID STRING REFERENCES DimStudent(StudentID),
    CourseID STRING REFERENCES DimCourse(CourseID),
    ProgramID STRING REFERENCES DimProgram(ProgramID),
    FinalGrades DOUBLE,
    YearLevel STRING,
    SchoolYear STRING,
    Semester STRING,
    StudentStatus STRING
) USING DELTA;
