using Movement.Controllers;
using UnityEngine;

namespace Audio
{
    public class EngineSoundSimple : MonoBehaviour
    {
        [SerializeField] private AudioSource _source;

        [SerializeField] private InputController _inputController;

        [SerializeField] private float _volumeAcceleration;

        private void Update()
        {
            var volume = _source.volume;
            var delta = _inputController.IsRunning ? _volumeAcceleration : -_volumeAcceleration;
            volume += delta;
            volume = Mathf.Clamp01(volume);
            _source.volume = volume;
        }
    }
}