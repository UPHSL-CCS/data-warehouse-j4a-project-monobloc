SELECT 
    f.YearLevel,
    f.StudentStatus,
    p.Department,
    COUNT(DISTINCT f.StudentID) as StudentCount,
    AVG(f.FinalGrades) as AvgGrade,
    MIN(f.FinalGrades) as MinGrade,
    MAX(f.FinalGrades) as MaxGrade,
    STDDEV(f.FinalGrades) as GradeStdDev
FROM FactEnrollment f
JOIN DimProgram p ON f.ProgramID = p.ProgramID
WHERE f.SchoolYear = '2019-2020'   
GROUP BY f.YearLevel, f.StudentStatus, p.Department
ORDER BY f.YearLevel, p.Department;