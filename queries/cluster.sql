SELECT 
    p.ProgramName,
    p.Department,
    f.YearLevel,
    f.StudentStatus,
    COUNT(DISTINCT f.StudentID) as StudentCount,
    COUNT(f.EnrollmentID) as TotalEnrollments,
    AVG(f.FinalGrades) as AvgGrade,
    ROUND(AVG(f.FinalGrades), 2) as RoundedAvgGrade
FROM FactEnrollment f
JOIN DimProgram p ON f.ProgramID = p.ProgramID
WHERE f.SchoolYear = '2019-2020'
  AND f.ProgramID IN ('aet', 'amt', 'beed')
GROUP BY p.ProgramName, p.Department, f.YearLevel, f.StudentStatus
ORDER BY StudentCount DESC;