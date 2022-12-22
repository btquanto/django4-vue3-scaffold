# pylint: disable=unused-import
import tensorflow_text
import tensorflow_hub as hub

model = hub.load("https://tfhub.dev/google/universal-sentence-encoder-multilingual/3")

# pylint: disable=invalid-name
def USE_vectorize(inputs):
    """
    Vectorize text using Universal Sentence Encoder
    Parameters:
        inputs (list): List of text to vectorize
    """
    return model(inputs).numpy().tolist()
