class Course {
    constructor() {
        this.id = "CSE-101";
        this.title = "Introduction to Computer Science";
        this.department = "Computer Science";
        this.instructor = {
            name: "Dr. Jane Smith",
            office: "Room 404",
            email: "jane.smith@university.edu",
            officeHours: [
                {
                    day: "Monday",
                    time: "10:00-12:00",
                },
                {
                    day: "Wednesday",
                    time: "14:00-16:00",
                },
            ],
        };
        this.schedule = {
            lectures: [
                {
                    day: "Monday",
                    time: "08:00-09:30",
                    location: "Building A, Room 101",
                },
                {
                    day: "Wednesday",
                    time: "08:00-09:30",
                    location: "Building A, Room 101",
                },
                {
                    day: "Friday",
                    time: "08:00-09:30",
                    location: "Building A, Room 101",
                },
            ],
            labs: [
                {
                    section: "L1",
                    day: "Tuesday",
                    time: "13:00-15:00",
                    location: "Lab Building, Room 201",
                },
                {
                    section: "L2",
                    day: "Thursday",
                    time: "13:00-15:00",
                    location: "Lab Building, Room 202",
                },
            ],
        };
        this.syllabus = {
            description:
                "This course provides an introduction to the fundamental concepts of computer science, including programming, algorithms, data structures, and software engineering.",
            topics: [
                "Introduction to Programming",
                "Basic Data Structures",
                "Algorithms",
                "Software Engineering Principles",
                "Databases",
                "Computer Networks",
            ],
            textbooks: [
                {
                    title: "Computer Science: An Overview",
                    author: "J. Glenn Brookshear",
                    edition: "12th",
                },
                {
                    title: "Introduction to Algorithms",
                    author: "Thomas H. Cormen",
                    edition: "3rd",
                },
            ],
            grading: {
                assignments: 30,
                quizzes: 20,
                midterm: 20,
                final: 30,
            },
        };
        this.students = [
            {
                id: "stu-001",
                name: "Alice Johnson",
                email: "alice.johnson@university.edu",
                grades: {
                    assignments: 85,
                    quizzes: 87,
                    midterm: 90,
                    final: 92,
                },
            },
            {
                id: "stu-002",
                name: "Bob Lee",
                email: "bob.lee@university.edu",
                grades: {
                    assignments: 78,
                    quizzes: 82,
                    midterm: 75,
                    final: 80,
                },
            },
            {
                id: "stu-003",
                name: "Carol King",
                email: "carol.king@university.edu",
                grades: {
                    assignments: 95,
                    quizzes: 98,
                    midterm: 94,
                    final: 96,
                },
            },
        ];
    }

    // Method to add a new student to the course
    addStudent(student) {
        this.students.push(student);
    }

    // Method to remove a student by ID
    removeStudentById(studentId) {
        this.students = this.students.filter(
            (student) => student.id !== studentId
        );
    }

    // Method to get student information by ID
    getStudentById(studentId) {
        return this.students.find((student) => student.id === studentId);
    }

    // Method to update the grade for a student
    updateStudentGrade(studentId, gradeType, gradeValue) {
        const student = this.getStudentById(studentId);
        if (student && student.grades.hasOwnProperty(gradeType)) {
            student.grades[gradeType] = gradeValue;
        }
    }

    // Method to calculate the average grade for a specific grade type
    calculateAverageGrade(gradeType) {
        const total = this.students.reduce((acc, student) => {
            if (student.grades.hasOwnProperty(gradeType)) {
                return acc + student.grades[gradeType];
            }
            return acc;
        }, 0);
        return total / this.students.length;
    }

    // Method to list all students enrolled in the course
    listStudents() {
        return this.students.map(
            (student) => `${student.name} (${student.id})`
        );
    }
}

// Example usage:
const course = new Course();
course.addStudent({ id: "stu-004", name: "Dave Lee", email: "dave.lee@university.edu", grades: { assignments: 80, quizzes: 85, midterm: 90, final: 88 } });
console.log(course.listStudents());
course.updateStudentGrade("stu-004", "final", 92);
console.log(course.getStudentById("stu-004"));
console.log(`Average midterm grade: ${course.calculateAverageGrade("midterm")}`);

