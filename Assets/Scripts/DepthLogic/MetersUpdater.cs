using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace DepthLogic
{
    public class MetersUpdater : MonoBehaviour
    {
        [SerializeField] private Transform _target;
        [SerializeField] private FloatVariable _metersVariable;
        [SerializeField] private float _scale;
        
        private void Update()
        {
            var depth = _target.position.y;
            depth /= _scale;
            _metersVariable.Value = -depth;
        }
    }
}