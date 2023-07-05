package main

import (
	"database/sql"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

type Cerita struct {
	Judul     string `json:"judul"`
	Gambar    string `json:"gambar"`
	Video     string `json:"videourl"`
	Ceritax   string `json:"deskripsi"`
	IdPenulis string `json:"fkg_penulis"`
	Likes     string `json:"likes"`
	IdCerita  string `json:"id_cerita"`
	Status    string `json:"status"`
}

type AnakModel struct {
}

type UserModel struct {
	UUID     string `json:"uuid"`
	Nama     string `json:"nama"`
	Password string `json:"password"`
	Role     string `json:"role"`
	Alamat   string `json:"alamat"`
}

func OpenDatabase() (*sql.DB, error) {
	db, err := sql.Open("mysql", "root:root@tcp(localhost:3306)/sicandb")
	if err != nil {
		return nil, err
	}
	return db, nil
}

func upload(c echo.Context) error {
	// Source
	file, err := c.FormFile("file")
	if err != nil {
		return err
	}
	src, err := file.Open()
	if err != nil {
		return err
	}
	defer src.Close()

	// Destination
	uploadDir := "upload/"
	idPenulis := c.FormValue("id_penulis")
	penulisDir := filepath.Join(uploadDir, idPenulis)
	if _, err := os.Stat(penulisDir); os.IsNotExist(err) {
		// Buat folder baru jika tidak ada
		err = os.MkdirAll(penulisDir, os.ModePerm)
		if err != nil {
			return err
		}
	}

	fileExtension := filepath.Ext(file.Filename)
	fileName := time.Now().Format("20060102150405") + "-" + idPenulis + fileExtension
	dstPath := filepath.Join(penulisDir, fileName)
	dst, err := os.Create(dstPath)
	if err != nil {
		return err
	}
	defer dst.Close()

	// Salin file gambar
	if _, err = io.Copy(dst, src); err != nil {
		return err
	}

	// Video
	video, err := c.FormFile("video")
	if err != nil {
		return err
	}
	srcVideo, err := video.Open()
	if err != nil {
		return err
	}
	defer srcVideo.Close()

	videoExtension := filepath.Ext(video.Filename)
	videoName := time.Now().Format("20060102150405") + "-" + idPenulis + videoExtension
	dstVideoPath := filepath.Join(penulisDir, videoName)
	dstVideo, err := os.Create(dstVideoPath)
	if err != nil {
		return err
	}
	defer dstVideo.Close()

	// Salin file video
	if _, err = io.Copy(dstVideo, srcVideo); err != nil {
		return err
	}

	// Simpan data ke database
	cerita := Cerita{
		Judul:     c.FormValue("judul"),
		Gambar:    filepath.Join(fileName),
		Video:     filepath.Join(videoName),
		Ceritax:   c.FormValue("cerita"),
		IdPenulis: idPenulis,
	}

	// Dapatkan objek *l.DB dari fungsi OpenDatabase()
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	// Menjalankan query INSERT
	_, err = db.Exec("call tambah_data_tbl_cerita(?, ?, ?, '1', ?, '0', ?)", cerita.Judul, cerita.Video, cerita.Ceritax, cerita.IdPenulis, cerita.Gambar)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":   200,
			"status": "ok",
		},
	})
}

func getCeritaByPenulis(c echo.Context) error {
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	IDPenulis := c.FormValue("penulis")

	rows, err := db.Query("CALL select_cerita_by_penulis(?)", IDPenulis)
	if err != nil {
		return err
	}
	defer rows.Close()

	data := []Cerita{}
	for rows.Next() {
		var cerita Cerita
		err := rows.Scan(&cerita.IdCerita, &cerita.Judul, &cerita.Video, &cerita.Gambar, &cerita.Ceritax, &cerita.Status, &cerita.IdPenulis, &cerita.Likes)
		if err != nil {
			return err
		}

		data = append(data, cerita)
	}

	if err = rows.Err(); err != nil {
		return err
	}

	if len(data) == 0 {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":    http.StatusNotFound,
				"koneksi": "ok",
			},
			"response": "Data not found",
		})
	} else {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":    http.StatusOK,
				"koneksi": "ok",
			},
			"response": data,
		})
	}
}

func getCeritaByID(c echo.Context) error {
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	Idcerita := c.FormValue("idcerita")

	rows, err := db.Query("CALL  select_cerita_detail(?)", Idcerita)
	if err != nil {
		return err
	}
	defer rows.Close()

	data := []Cerita{}
	for rows.Next() {
		var cerita Cerita
		err := rows.Scan(&cerita.IdCerita, &cerita.Judul, &cerita.Video, &cerita.Gambar, &cerita.Ceritax, &cerita.Status, &cerita.IdPenulis, &cerita.Likes)
		if err != nil {
			return err
		}

		data = append(data, cerita)
	}

	if err = rows.Err(); err != nil {
		return err
	}

	if len(data) == 0 {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":    http.StatusNotFound,
				"koneksi": "ok",
			},
			"response": "Data not found",
		})
	} else {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":    http.StatusOK,
				"koneksi": "ok",
			},
			"response": data,
		})
	}
}

func getCeritaAll(c echo.Context) error {
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()
	rows, err := db.Query("call ambil_data_tbl_cerita_active()")
	if err != nil {
		return err
	}
	defer rows.Close()
	data := []Cerita{}
	for rows.Next() {
		var cerita Cerita

		err := rows.Scan(&cerita.IdCerita, &cerita.Judul, &cerita.Video, &cerita.Gambar, &cerita.Ceritax, &cerita.IdPenulis, &cerita.Likes)
		if err != nil {
			return err
		}

		data = append(data, cerita)
	}
	if err = rows.Err(); err != nil {
		return err
	}
	if len(data) == 0 {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":    404,
				"koneksi": "ok",
			},
			"response": "data kosong",
		})
	} else {
		return c.JSON(http.StatusOK, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":    200,
				"koneksi": "ok",
			},
			"response": data,
		})
	}
}

func login(c echo.Context) error {
	username := c.FormValue("username")
	password := c.FormValue("password")

	// Perform authentication logic by querying the database
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	var user UserModel

	err = db.QueryRow("call GetUserByUsername(?)", username).Scan(&user.UUID, &user.Nama, &user.Password, &user.Role, &user.Alamat)
	if err != nil {
		// User not found or error occurred during the query
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":   http.StatusUnauthorized,
				"status": "error",
			},
			"response": err,
		})
	}

	// Validate the password
	if password != user.Password {
		// Passwords don't match
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":   http.StatusUnauthorized,
				"status": "error",
			},
			"response": "Invalid username or password",
		})
	}
	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":   http.StatusOK,
			"status": "ok",
		},
		"response": user,
	})
}

func register(c echo.Context) error {
	password := c.FormValue("password")
	nama := c.FormValue("nama")
	alamat := c.FormValue("alamat")
	role := c.FormValue("role")

	// Perform validation on input data
	if password == "" || nama == "" || alamat == "" || role == "" {
		// If any required field is missing, return an error response
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":   http.StatusBadRequest,
				"status": "error",
			},
			"response": "Missing required fields",
		})
	}

	// Perform registration logic by inserting data into the database
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	var count int
	err = db.QueryRow("SELECT COUNT(*) FROM users WHERE nama = ?", nama).Scan(&count)
	if err != nil {

		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":   http.StatusInternalServerError,
				"status": "error",
			},
			"response": err,
		})
	}

	if count > 0 {
		// Username already exists, return error response
		return c.JSON(http.StatusConflict, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":   http.StatusConflict,
				"status": "error",
			},
			"response": "Username already exists",
		})
	}

	// Insert the user data into the database
	_, err = db.Exec("Call tambah_data_users(?,?,?,?)", nama, password, role, alamat)
	if err != nil {
		// Error occurred during the database insertion
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":   http.StatusInternalServerError,
				"status": "error",
			},
			"response": err,
		})
	}

	// Registration successful
	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":   http.StatusOK,
			"status": "ok",
		},
		"response": "Registration successful",
	})
}

func edit(c echo.Context) error {
	idCerita := c.FormValue("id_cerita")
	judul := c.FormValue("judul")
	cerita := c.FormValue("cerita")

	// Check if file is uploaded
	file, err := c.FormFile("file")
	if err != nil && err != http.ErrMissingFile {
		return err
	}

	// Check if video is uploaded
	video, err := c.FormFile("video")
	if err != nil && err != http.ErrMissingFile {
		return err
	}

	// Retrieve existing data from the database
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	// Retrieve existing image and video URLs
	var gambarLama string
	var videoLama string
	var idpenulis string
	err = db.QueryRow("SELECT gambar, videourl,fkg_penulis FROM tbl_cerita WHERE id_cerita = ?", idCerita).Scan(&gambarLama, &videoLama, &idpenulis)
	if err != nil {
		return err
	}

	// Destination folder
	uploadDir := "upload/"
	idPenulis := idpenulis
	penulisDir := filepath.Join(uploadDir, idPenulis)
	// Handle file upload
	var gambarBaru string

	if file != nil {
		// Delete the old image file
		if gambarLama != "" {
			err = os.Remove(filepath.Join(uploadDir, idPenulis, gambarLama))
			if err != nil {
				return err
			}
		}

		// Source
		src, err := file.Open()
		if err != nil {
			return err
		}
		defer src.Close()

		// Destination

		if _, err := os.Stat(penulisDir); os.IsNotExist(err) {
			// Create a new folder if it doesn't exist
			err = os.MkdirAll(penulisDir, os.ModePerm)
			if err != nil {
				return err
			}
		}

		fileExtension := filepath.Ext(file.Filename)
		gambarBaru = time.Now().Format("20060102150405") + "-" + idPenulis + fileExtension
		dstPath := filepath.Join(penulisDir, gambarBaru)
		dst, err := os.Create(dstPath)
		if err != nil {
			return err
		}
		defer dst.Close()

		// Copy the image file
		if _, err = io.Copy(dst, src); err != nil {
			return err
		}
	} else {
		// If file is not uploaded, use the existing image URL
		gambarBaru = gambarLama
	}

	// Handle video upload
	var videoBaru string

	if video != nil {
		// Delete the old video file
		if videoLama != "" {
			err = os.Remove(filepath.Join(uploadDir, idPenulis, videoLama))
			if err != nil {
				return err
			}
		}

		// Source
		srcVideo, err := video.Open()
		if err != nil {
			return err
		}
		defer srcVideo.Close()

		// Destination
		videoExtension := filepath.Ext(video.Filename)
		videoBaru = time.Now().Format("20060102150405") + "-" + idPenulis + videoExtension
		dstVideoPath := filepath.Join(penulisDir, videoBaru)
		dstVideo, err := os.Create(dstVideoPath)
		if err != nil {
			return err
		}
		defer dstVideo.Close()

		// Copy the video file
		if _, err = io.Copy(dstVideo, srcVideo); err != nil {
			return err
		}
	} else {
		// If video is not uploaded, use the existing video URL
		videoBaru = videoLama
	}

	// Update data in the database
	_, err = db.Exec("UPDATE tbl_cerita SET judul = ?, deskripsi = ?, gambar = ?, videourl = ? WHERE id_cerita = ?", judul, cerita, gambarBaru, videoBaru, idCerita)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":   http.StatusOK,
			"status": "ok",
		},
		"response": "cerita di update",
	})
}

func updateStatus(c echo.Context) error {
	idCerita := c.FormValue("id_cerita")
	status := c.FormValue("status")

	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	_, err = db.Exec("UPDATE tbl_cerita SET status = ? WHERE id_cerita = ?", status, idCerita)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":   http.StatusOK,
			"status": "ok",
		},
	})
}
func updateUser(c echo.Context) error {
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	uuidParam := c.FormValue("uuid")
	namaParam := c.FormValue("nama")
	passwordParam := c.FormValue("password")
	roleParam := c.FormValue("role")
	alamatParam := c.FormValue("alamat")

	// Check if there is a duplicate name
	var duplicateCount int
	err = db.QueryRow("call check_duplicate_name(?,?)", namaParam, uuidParam).Scan(&duplicateCount)
	if err != nil {
		return err
	}

	if duplicateCount > 0 {
		// Return duplicate name error
		return c.JSON(http.StatusConflict, map[string]interface{}{
			"metadata": map[string]interface{}{
				"code":    http.StatusConflict,
				"koneksi": "ok",
			},
			"response": "Duplicate name",
		})
	}

	// Perform the update if no duplicate name
	_, err = db.Exec("UPDATE users SET nama = ?, password = ?, role = ?, alamat = ? WHERE uuid_users = ?",
		namaParam, passwordParam, roleParam, alamatParam, uuidParam)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":    http.StatusOK,
			"koneksi": "ok",
		},
		"response": "User updated successfully",
	})
}

func tambahLikes(c echo.Context) error {
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	idCerita := c.FormValue("idcerita")

	_, err = db.Exec("CALL tambah_likes(?)", idCerita)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":    http.StatusOK,
			"koneksi": "ok",
		},
		"response": "Likes added successfully",
	})
}

func deleteCerita(c echo.Context) error {
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	idCerita := c.Param("idcerita")

	_, err = db.Query("CALL delete_cerita(?)", idCerita)
	if err != nil {
		return err
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":    http.StatusOK,
			"koneksi": "ok",
		},
		"response": "Cerita deleted successfully",
	})
}

func getJumlahCeritaLikesByPenulis(c echo.Context) error {
	db, err := OpenDatabase()
	if err != nil {
		return err
	}
	defer db.Close()

	penulisID := c.FormValue("id_penulis")

	rows, err := db.Query("CALL hitung_jumlah_cerita_likes_by_penulis(?)", penulisID)
	if err != nil {
		return err
	}
	defer rows.Close()

	result := []map[string]interface{}{}
	for rows.Next() {
		var penulis string
		var jumlahCerita, jumlahLikes int
		err := rows.Scan(&penulis, &jumlahCerita, &jumlahLikes)
		if err != nil {
			return err
		}
		data := map[string]interface{}{
			"fkg_penulis":   penulis,
			"jumlah_cerita": jumlahCerita,
			"jumlah_likes":  jumlahLikes,
		}
		result = append(result, data)
	}
	if err = rows.Err(); err != nil {
		return err
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"metadata": map[string]interface{}{
			"code":    http.StatusOK,
			"koneksi": "ok",
		},
		"response": result,
	})
}

func serveImage(c echo.Context) error {
	imagePath := strings.TrimPrefix(c.Request().URL.Path, "/assets/")
	imagePath = filepath.Join("upload/", imagePath)
	return c.File(imagePath)
}

func main() {
	e := echo.New()
	// Middleware
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.Use(allowAllOriginsMiddleware())
	// Routes
	e.POST("/upload", upload)
	e.POST("/login", login)
	e.GET("/assets/*", serveImage)
	e.GET("/cerita", getCeritaAll)
	e.POST("/registrasi", register)
	e.PUT("/editcerita", edit)
	e.PUT("/updatestatus", updateStatus)
	e.POST("/ceritabypenulis", getCeritaByPenulis)
	e.DELETE("/deletecerita/:idcerita", deleteCerita)
	e.POST("/jumlahceritabypenulis", getJumlahCeritaLikesByPenulis)
	e.POST("/addlikes", tambahLikes)
	e.POST("/updateusers", updateUser)
	e.POST("/getCeritaByID", getCeritaByID)

	if err := e.Start(":1500"); err != nil {
		e.Logger.Fatal(err)
	}
}
func allowAllOriginsMiddleware() echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			c.Response().Header().Set(echo.HeaderAccessControlAllowOrigin, "*")
			c.Response().Header().Set(echo.HeaderAccessControlAllowMethods, "GET, POST, PUT, DELETE, OPTIONS")
			c.Response().Header().Set(echo.HeaderAccessControlAllowHeaders, "Content-Type, Authorization")

			if c.Request().Method == echo.OPTIONS {
				return c.NoContent(http.StatusNoContent)
			}

			return next(c)
		}
	}
}
