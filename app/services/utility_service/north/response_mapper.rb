module UtilityService
  module North
    class ResponseMapper < UtilityService::ResponseMapper
      def retrieve_books(_response_code, response_body)
        { books: map_books(response_body['libros']) }
      end

      def retrieve_notes(_response_code, response_body)
        { notes: map_notes(response_body['notas']) }
      end

      private

      def map_books(books)
        books.map do |book|
          {
            id: book['id'],
            title: book['titulo'],
            author: book['autor'],
            genre: book['genero'],
            image_url: book['imagen_url'],
            publisher: book['editorial'],
            year: book['año']
          }
        end
      end

      def map_user_notes(autor)
          {
           email: autor['datos_de_contacto']['email'],
           first_name: autor['datos_personales']['nombre'],
           last_name: autor['datos_personales']['apellido']
          }
        end
      end

      def map_book_notes(book)
          {
           title: book['titulo'],
           author: book['autor'],
           genre: book['genero'],
          }
        end
      end
      
      def map_notes(notes)
        notes.map do |note|
          {
            title: note['titulo'],
            type: note['tipo'],
            created_at: note['fecha_creacion'],
            content: note['contenido'],
            user: map_user_notes(note['autor']),
            book: map_book_notes(note['libro'])
          }
        end
      end
    end
  end
end
